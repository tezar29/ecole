import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models.dart';
import '../../core/providers.dart';

/// Choix du profil enfant (ou création d'un nouveau profil).
class ChildrenPage extends ConsumerWidget {
  const ChildrenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qui veut apprendre ?'),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(supabaseProvider).auth.signOut(),
          ),
        ],
      ),
      body: children.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) => GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            for (final c in list)
              _ChildCard(
                child: c,
                onTap: () {
                  ref.read(selectedChildProvider.notifier).state = c;
                  context.go('/home');
                },
              ),
            _AddCard(onTap: () => _showAddDialog(context, ref)),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    var level = SchoolLevel.sil;
    var avatar = kAvatars.keys.first;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Nouvel enfant'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<SchoolLevel>(
                  value: level,
                  decoration: const InputDecoration(labelText: 'Classe'),
                  items: [
                    for (final l in SchoolLevel.values)
                      DropdownMenuItem(value: l, child: Text(l.label)),
                  ],
                  onChanged: (v) => setState(() => level = v ?? level),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final e in kAvatars.entries)
                      ChoiceChip(
                        label: Text(e.value, style: const TextStyle(fontSize: 28)),
                        selected: avatar == e.key,
                        onSelected: (_) => setState(() => avatar = e.key),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(120, 48)),
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                final client = ref.read(supabaseProvider);
                await client.from('children').insert({
                  'parent_id': client.auth.currentUser!.id,
                  'name': name,
                  'avatar': avatar,
                  'level': level.name,
                });
                ref.invalidate(childrenProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
    nameCtrl.dispose();
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({required this.child, required this.onTap});

  final Child child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(child.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            Text(child.name, style: theme.textTheme.titleLarge),
            Text(child.level.label, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  const _AddCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange.shade100,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: const Center(
          child: Icon(Icons.add_circle, size: 72, color: Colors.orange),
        ),
      ),
    );
  }
}
