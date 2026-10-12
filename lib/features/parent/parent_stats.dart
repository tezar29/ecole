import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models.dart';
import '../../core/providers.dart';

class SubjectStats {
  const SubjectStats({
    required this.subject,
    required this.total,
    required this.done,
    required this.stars,
  });

  final Subject subject;
  final int total; // chapitres disponibles dans la classe
  final int done; // chapitres terminés au moins une fois
  final int stars;

  double get ratio => total == 0 ? 0 : done / total;
}

class ChildStats {
  const ChildStats({
    required this.subjects,
    required this.lastActivity,
  });

  final List<SubjectStats> subjects;
  final DateTime? lastActivity;

  int get totalStars => subjects.fold(0, (a, s) => a + s.stars);
  int get doneChapters => subjects.fold(0, (a, s) => a + s.done);
  int get totalChapters => subjects.fold(0, (a, s) => a + s.total);
}

/// Statistiques d'un enfant (calculées à partir de la progression, copie locale si hors ligne).
final childStatsProvider = FutureProvider.autoDispose
    .family<ChildStats, ({String childId, SchoolLevel level})>((ref, args) async {
  final repo = ref.watch(repositoryProvider);

  final subjects = (await repo.subjects()).map(Subject.fromMap).toList();
  final index = await repo.chapterIndex(args.level);
  final progress = await repo.progressDetails(args.childId);

  final byChapter = {
    for (final r in progress) r['chapter_id'] as String: r,
  };

  final stats = <SubjectStats>[];
  for (final s in subjects) {
    final ids = [
      for (final c in index)
        if (c['subject_id'] == s.id) c['id'] as String,
    ];
    var done = 0;
    var stars = 0;
    for (final id in ids) {
      final r = byChapter[id];
      if (r != null && r['completed_at'] != null) {
        done++;
        stars += r['stars'] as int;
      }
    }
    stats.add(SubjectStats(subject: s, total: ids.length, done: done, stars: stars));
  }

  DateTime? last;
  for (final r in progress) {
    final d = DateTime.tryParse('${r['completed_at'] ?? ''}');
    if (d != null && (last == null || d.isAfter(last))) last = d;
  }

  return ChildStats(subjects: stats, lastActivity: last?.toLocal());
});
