import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand.dart';
import '../../core/models.dart';
import '../../core/providers.dart';
import 'parent_stats.dart';

/// Suivi de la progression des enfants (accès protégé par parent_gate).
class ParentPage extends ConsumerStatefulWidget {
  const ParentPage({super.key});

  @override
  ConsumerState<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends ConsumerState<ParentPage> {
  String? _selectedId;

  static String _ago(DateTime? d) {
    if (d == null) return 'Aucune';
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    return 'Il y a ${diff.inDays} j';
  }

  Future<void> _deleteChild(Child c) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Supprimer le profil de ${c.name} ?'),
        content: const Text('Sa progression sera effacée. Cette action est définitive.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(120, 48)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await ref.read(repositoryProvider).deleteChild(c.id);
      if (ref.read(selectedChildProvider)?.id == c.id) {
        ref.read(selectedChildProvider.notifier).state = null;
      }
      setState(() => _selectedId = null);
      ref.invalidate(childrenProvider);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connecte-toi à internet pour supprimer un profil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = ref.watch(childrenProvider);
    final repo = ref.watch(repositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Espace parent')),
      body: children.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aucun enfant pour le moment.\nAjoute un profil depuis l\'écran « Qui veut apprendre ? ».',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }

          final wanted = _selectedId ?? ref.read(selectedChildProvider)?.id;
          final child = list.firstWhere((c) => c.id == wanted, orElse: () => list.first);
          final stats = ref.watch(
            childStatsProvider((childId: child.id, level: child.level)),
          );
          final downloaded = repo.downloadedAt(child.level);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in list)
                    ChoiceChip(
                      label: Text('${c.emoji} ${c.name} · ${c.level.label}'),
                      selected: c.id == child.id,
                      onSelected: (_) => setState(() => _selectedId = c.id),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              stats.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => const Text(
                  'Impossible de charger le suivi. Connecte-toi à internet une première fois.',
                ),
                data: (s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            icon: Icons.star_rounded,
                            iconColor: Brand.ambre,
                            value: '${s.totalStars}',
                            label: 'Étoiles',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatTile(
                            icon: Icons.menu_book_rounded,
                            iconColor: Brand.sarcelle,
                            value: '${s.doneChapters}/${s.totalChapters}',
                            label: 'Chapitres',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatTile(
                            icon: Icons.schedule,
                            iconColor: Brand.bleuNuit,
                            value: _ago(s.lastActivity),
                            label: 'Dernière activité',
                            small: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Par matière', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    for (final st in s.subjects) _SubjectRow(stats: st),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Mode hors ligne', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        downloaded == null
                            ? 'Leçons ${child.level.label} : pas encore téléchargées.'
                            : 'Leçons ${child.level.label} téléchargées le '
                                '${downloaded.day.toString().padLeft(2, '0')}/'
                                '${downloaded.month.toString().padLeft(2, '0')}.',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        repo.pendingCount == 0
                            ? 'Toute la progression est synchronisée.'
                            : '${repo.pendingCount} résultat(s) en attente d\'envoi (internet requis).',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.go('/children'),
                icon: const Icon(Icons.groups),
                label: const Text('Gérer les profils enfants'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _deleteChild(child),
                icon: const Icon(Icons.delete_outline),
                label: Text('Supprimer le profil de ${child.name}'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  ref.read(selectedChildProvider.notifier).state = null;
                  ref.read(supabaseProvider).auth.signOut();
                },
                child: const Text('Me déconnecter'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.small = false,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: iconColor),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: small ? 16 : 24,
              fontWeight: FontWeight.w900,
              color: Brand.bleuNuit,
            ),
          ),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.stats});

  final SubjectStats stats;

  @override
  Widget build(BuildContext context) {
    final color = stats.subject.colorValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(stats.subject.iconData, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stats.subject.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: stats.ratio,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stats.total == 0
                        ? 'Pas encore de leçons'
                        : '${stats.done}/${stats.total} chapitres · ${stats.stars} étoiles',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
