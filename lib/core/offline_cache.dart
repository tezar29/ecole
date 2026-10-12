import 'dart:convert';
import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';

/// Petit cache local (Hive) :
/// - `cache`    : copies JSON des matières, chapitres, exercices, profils, progression
/// - `pending`  : progression enregistrée hors ligne, à envoyer plus tard
class OfflineCache {
  OfflineCache._(this._box, this._pending);

  final Box<String> _box;
  final Box<String> _pending;

  static Future<OfflineCache> open() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>('cache');
    final pending = await Hive.openBox<String>('pending_progress');
    return OfflineCache._(box, pending);
  }

  Future<void> put(String key, Object value) => _box.put(key, jsonEncode(value));

  /// Valeur décodée (Map, List, String...) ou null si absente.
  dynamic get(String key) {
    final s = _box.get(key);
    return s == null ? null : jsonDecode(s);
  }

  // ---- Progression en attente d'envoi ------------------------------------

  /// Garde la meilleure note si une entrée existe déjà pour ce chapitre.
  Future<void> enqueueProgress(Map<String, dynamic> row) async {
    final key = '${row['child_id']}|${row['chapter_id']}';
    final existing = _pending.get(key);
    var stars = row['stars'] as int;
    if (existing != null) {
      stars = max(stars, (jsonDecode(existing) as Map)['stars'] as int);
    }
    await _pending.put(key, jsonEncode({...row, 'stars': stars}));
  }

  List<MapEntry<String, Map<String, dynamic>>> pendingEntries() => [
        for (final k in _pending.keys.cast<String>())
          MapEntry(
            k,
            Map<String, dynamic>.from(jsonDecode(_pending.get(k)!) as Map),
          ),
      ];

  Future<void> removePending(String key) => _pending.delete(key);

  int get pendingCount => _pending.length;
}
