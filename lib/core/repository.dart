import 'dart:math';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';
import 'offline_cache.dart';

/// Accès aux données avec mode hors ligne :
/// 1. on essaie Supabase (8 s max) et on mémorise le résultat ;
/// 2. si le réseau échoue, on lit la copie locale.
class ContentRepository {
  ContentRepository(this._client, this._cache);

  final SupabaseClient _client;
  final OfflineCache _cache;

  static const _timeout = Duration(seconds: 8);

  String get _uid => _client.auth.currentUser?.id ?? 'anon';

  List<Map<String, dynamic>> _asRows(dynamic data) => (data as List)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();

  Future<List<Map<String, dynamic>>> _cachedList(
    String key,
    Future<dynamic> Function() fetch, {
    bool fresh = false,
  }) async {
    try {
      final rows = _asRows(await fetch().timeout(_timeout));
      await _cache.put(key, rows);
      return rows;
    } catch (_) {
      final cached = _cache.get(key);
      if (!fresh && cached != null) return _asRows(cached);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> children() => _cachedList(
        'children:$_uid',
        () => _client.from('children').select().order('created_at'),
      );

  Future<List<Map<String, dynamic>>> subjects({bool fresh = false}) =>
      _cachedList(
        'subjects',
        () => _client.from('subjects').select().order('id'),
        fresh: fresh,
      );

  Future<List<Map<String, dynamic>>> chapters(
    int subjectId,
    SchoolLevel level, {
    bool fresh = false,
  }) =>
      _cachedList(
        'chapters:$subjectId:${level.name}',
        () => _client
            .from('chapters')
            .select()
            .eq('subject_id', subjectId)
            .eq('level', level.name)
            .order('position'),
        fresh: fresh,
      );

  Future<List<Map<String, dynamic>>> exercises(
    String chapterId, {
    bool fresh = false,
  }) =>
      _cachedList(
        'exercises:$chapterId',
        () => _client
            .from('exercises')
            .select()
            .eq('chapter_id', chapterId)
            .order('position'),
        fresh: fresh,
      );

  // ---- Progression -------------------------------------------------------

  Map<String, int> _localProgress(String childId) {
    final c = _cache.get('progress:$childId');
    if (c == null) return {};
    return (c as Map).map((k, v) => MapEntry(k as String, v as int));
  }

  /// Ajoute la progression pas encore envoyée (meilleure note par chapitre).
  Map<String, int> _withPending(String childId, Map<String, int> base) {
    final out = Map<String, int>.of(base);
    for (final e in _cache.pendingEntries()) {
      final p = e.value;
      if (p['child_id'] == childId) {
        final id = p['chapter_id'] as String;
        out[id] = max(out[id] ?? 0, p['stars'] as int);
      }
    }
    return out;
  }

  Future<Map<String, int>> progress(String childId) async {
    try {
      final rows = _asRows(await _client
          .from('progress')
          .select('chapter_id, stars')
          .eq('child_id', childId)
          .timeout(_timeout));
      final map = {
        for (final r in rows) r['chapter_id'] as String: r['stars'] as int,
      };
      await _cache.put('progress:$childId', map);
      return _withPending(childId, map);
    } catch (_) {
      return _withPending(childId, _localProgress(childId));
    }
  }

  /// Enregistre la progression : envoyée tout de suite si le réseau répond,
  /// sinon mise en file d'attente et envoyée plus tard (voir [syncPending]).
  Future<void> saveProgress({
    required String childId,
    required String chapterId,
    required int stars,
    required int score,
  }) async {
    final known = _withPending(childId, _localProgress(childId));
    final best = max(stars, known[chapterId] ?? 0);
    final now = DateTime.now().toIso8601String();
    final row = {
      'child_id': childId,
      'chapter_id': chapterId,
      'stars': best,
      'score': score,
      'completed_at': now,
      'updated_at': now,
    };

    // L'affichage des étoiles est mis à jour immédiatement.
    final local = _localProgress(childId);
    local[chapterId] = best;
    await _cache.put('progress:$childId', local);

    try {
      await _client
          .from('progress')
          .upsert(row, onConflict: 'child_id,chapter_id')
          .timeout(_timeout);
    } catch (_) {
      await _cache.enqueueProgress(row);
    }
  }

  /// Envoie la progression gardée hors ligne. Retourne le nombre d'éléments envoyés.
  Future<int> syncPending() async {
    var sent = 0;
    for (final e in _cache.pendingEntries()) {
      try {
        await _client
            .from('progress')
            .upsert(e.value, onConflict: 'child_id,chapter_id')
            .timeout(_timeout);
        await _cache.removePending(e.key);
        sent++;
      } catch (_) {
        break; // toujours hors ligne : on réessaiera plus tard
      }
    }
    return sent;
  }

  int get pendingCount => _cache.pendingCount;

  // ---- Suivi parent ------------------------------------------------------

  /// Détail de la progression d'un enfant (une ligne par chapitre travaillé).
  Future<List<Map<String, dynamic>>> progressDetails(String childId) =>
      _cachedList(
        'progress_details:$childId',
        () => _client
            .from('progress')
            .select('chapter_id, stars, score, completed_at')
            .eq('child_id', childId),
      );

  /// Liste légère de tous les chapitres publiés d'une classe.
  Future<List<Map<String, dynamic>>> chapterIndex(SchoolLevel level) =>
      _cachedList(
        'chapter_index:${level.name}',
        () => _client
            .from('chapters')
            .select('id, subject_id, title')
            .eq('level', level.name),
      );

  /// Supprime un profil enfant (sa progression est supprimée avec). Nécessite internet.
  Future<void> deleteChild(String childId) async {
    await _client.from('children').delete().eq('id', childId).timeout(_timeout);
  }

  // ---- Téléchargement pour travailler sans internet -----------------------

  DateTime? downloadedAt(SchoolLevel level) {
    final s = _cache.get('meta:downloaded:${level.name}');
    return s is String ? DateTime.tryParse(s) : null;
  }

  /// Télécharge toutes les matières, chapitres, exercices (et images des leçons)
  /// de la classe donnée. Lève une erreur si le réseau est indisponible.
  Future<void> downloadForOffline(
    SchoolLevel level, {
    void Function(double progress)? onProgress,
  }) async {
    final subjectRows = await subjects(fresh: true);

    final chapterRows = <Map<String, dynamic>>[];
    for (final s in subjectRows) {
      chapterRows.addAll(await chapters(s['id'] as int, level, fresh: true));
    }

    final total = max(1, chapterRows.length);
    var done = 0;
    for (final c in chapterRows) {
      await exercises(c['id'] as String, fresh: true);
      await _prefetchImages(c);
      done++;
      onProgress?.call(done / total);
    }

    await _cache.put('meta:downloaded:${level.name}', DateTime.now().toIso8601String());
    onProgress?.call(1);
  }

  Future<void> _prefetchImages(Map<String, dynamic> chapter) async {
    final content = chapter['content'];
    if (content is! Map) return;
    final blocks = (content['blocks'] as List?) ?? const [];
    for (final b in blocks) {
      if (b is Map && b['type'] == 'image' && b['url'] is String) {
        try {
          await DefaultCacheManager().downloadFile(b['url'] as String);
        } catch (_) {
          // une image manquante ne bloque pas le téléchargement
        }
      }
    }
  }
}
