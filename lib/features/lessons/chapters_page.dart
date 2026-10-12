import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models.dart';
import '../../core/providers.dart';

/// Liste des chapitres d'une matière, pour la classe de l'enfant.
class ChaptersPage extends ConsumerWidget {
  const ChaptersPage({super.key, required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(selectedChildProvider);
    if (child == null) {
      return const Scaffold(body: Center(child: Text('Choisis d\'abord un enfant')));
    }

    final chapters = ref.watch(
      chaptersProvider((subjectId: subject.id, level: child.level)),
    );
    final stars =
        ref.watch(progressProvider(child.id)).valueOrNull ?? const <String, int>{};
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${subject.name} · ${child.level.label}'),
        backgroundColor: subject.colorValue.withAlpha(60),
      ),
      body: chapters.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'Bientôt de nouvelles leçons ! 🚀',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final c = list[i];
              final earned = stars[c.id] ?? 0;
              return Material(
                color: Colors.white,
                elevation: 2,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => context.push('/lesson', extra: c),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: subject.colorValue,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(c.title, style: theme.textTheme.titleLarge),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var s = 1; s <= 3; s++)
                              Icon(
                                s <= earned ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
