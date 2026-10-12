import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand.dart';
import '../../core/models.dart';
import '../../core/providers.dart';
import '../../shared/mascot.dart';
import '../../shared/offline_banner.dart';
import '../parent/parent_gate.dart';

/// Accueil de l'enfant : la mascotte l'accueille, puis les matières.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = ref.watch(selectedChildProvider);
    final subjects = ref.watch(subjectsProvider);

    if (child == null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => context.go('/children'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Changer d\'enfant',
          icon: const Icon(Icons.switch_account),
          onPressed: () => context.go('/children'),
        ),
        title: Text('${child.emoji} ${child.name} · ${child.level.label}'),
        actions: [
          IconButton(
            tooltip: 'Espace parent',
            icon: const Icon(Icons.lock_outline),
            onPressed: () async {
              if (await showParentGate(context) && context.mounted) {
                context.push('/parent');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Mascot(height: 120),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'Bonjour ${child.name} ! Qu\'est-ce qu\'on explore aujourd\'hui ?',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Brand.bleuNuit,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _DownloadCard(child: child),
          ),
          Expanded(
            child: subjects.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Impossible de charger les matières.\nConnecte-toi à internet une première fois, puis télécharge tes leçons.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              data: (list) => GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [for (final s in list) _SubjectCard(subject: s)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Télécharge les leçons de la classe pour travailler sans internet.
class _DownloadCard extends ConsumerStatefulWidget {
  const _DownloadCard({required this.child});

  final Child child;

  @override
  ConsumerState<_DownloadCard> createState() => _DownloadCardState();
}

class _DownloadCardState extends ConsumerState<_DownloadCard> {
  double? _progress; // non null pendant le téléchargement

  Future<void> _download() async {
    setState(() => _progress = 0);
    try {
      await ref.read(repositoryProvider).downloadForOffline(
            widget.child.level,
            onProgress: (p) {
              if (mounted) setState(() => _progress = p);
            },
          );
      ref.invalidate(subjectsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Leçons téléchargées !')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Téléchargement impossible : vérifie ta connexion.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _progress = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final at = repo.downloadedAt(widget.child.level);
    final busy = _progress != null;

    final subtitle = busy
        ? 'Téléchargement en cours…'
        : at == null
            ? 'Pour travailler sans internet'
            : 'Prêt hors ligne · mis à jour le ${at.day.toString().padLeft(2, '0')}/${at.month.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  at == null ? Icons.cloud_download_outlined : Icons.check_circle,
                  size: 36,
                  color: Brand.sarcelle,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mes leçons ${widget.child.level.label}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(subtitle, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: at == null ? 'Télécharger' : 'Mettre à jour',
                  onPressed: busy ? null : _download,
                  icon: Icon(at == null ? Icons.download : Icons.refresh),
                ),
              ],
            ),
            if (busy)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject});

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    final color = subject.colorValue;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.push('/subject', extra: subject),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(subject.iconData, size: 42, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              subject.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
