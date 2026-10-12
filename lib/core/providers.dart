import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';
import 'offline_cache.dart';
import 'repository.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

/// Fourni dans main() une fois le cache local ouvert.
final offlineCacheProvider = Provider<OfflineCache>(
  (ref) => throw UnimplementedError('offlineCacheProvider doit être surchargé dans main()'),
);

final repositoryProvider = Provider<ContentRepository>(
  (ref) => ContentRepository(
    ref.watch(supabaseProvider),
    ref.watch(offlineCacheProvider),
  ),
);

/// Profils enfants du parent connecté (copie locale si hors ligne).
final childrenProvider = FutureProvider.autoDispose<List<Child>>((ref) async {
  final rows = await ref.watch(repositoryProvider).children();
  return rows.map(Child.fromMap).toList();
});

/// Enfant actuellement sélectionné.
final selectedChildProvider = StateProvider<Child?>((ref) => null);

final subjectsProvider = FutureProvider.autoDispose<List<Subject>>((ref) async {
  final rows = await ref.watch(repositoryProvider).subjects();
  return rows.map(Subject.fromMap).toList();
});

/// Chapitres publiés d'une matière pour un niveau donné.
final chaptersProvider = FutureProvider.autoDispose
    .family<List<Chapter>, ({int subjectId, SchoolLevel level})>((ref, args) async {
  final rows =
      await ref.watch(repositoryProvider).chapters(args.subjectId, args.level);
  return rows.map(Chapter.fromMap).toList();
});

/// Exercices d'un chapitre.
final exercisesProvider =
    FutureProvider.autoDispose.family<List<Exercise>, String>((ref, chapterId) async {
  final rows = await ref.watch(repositoryProvider).exercises(chapterId);
  return rows.map(Exercise.fromMap).toList();
});

/// Étoiles obtenues par chapitre pour un enfant : { chapter_id: étoiles }.
final progressProvider =
    FutureProvider.autoDispose.family<Map<String, int>, String>(
  (ref, childId) => ref.watch(repositoryProvider).progress(childId),
);

/// true si un réseau est disponible (info indicative, pas une garantie d'accès à internet).
final onlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  bool isOnline(List<ConnectivityResult> r) => !r.contains(ConnectivityResult.none);
  yield isOnline(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(isOnline);
});

/// Envoie la progression gardée hors ligne dès que le réseau revient.
final syncServiceProvider = Provider<void>((ref) {
  final repo = ref.watch(repositoryProvider);
  var running = false;

  Future<void> run() async {
    if (running) return;
    running = true;
    try {
      final sent = await repo.syncPending();
      if (sent > 0) ref.invalidate(progressProvider);
    } catch (_) {
      // on réessaiera au prochain changement de connexion
    } finally {
      running = false;
    }
  }

  final sub = Connectivity().onConnectivityChanged.listen((results) {
    if (!results.contains(ConnectivityResult.none)) run();
  });
  ref.onDispose(sub.cancel);
  run();
});
