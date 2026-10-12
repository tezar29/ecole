import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/brand.dart';
import '../core/providers.dart';

/// Bandeau discret affiché quand l'appareil n'a pas de réseau.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(onlineProvider).valueOrNull ?? true;
    if (online) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: Brand.brume,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Row(
        children: [
          Icon(Icons.cloud_off, size: 20, color: Brand.bleuNuit),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pas de connexion : tu peux continuer avec tes leçons téléchargées.',
              style: TextStyle(fontSize: 15, color: Brand.bleuNuit),
            ),
          ),
        ],
      ),
    );
  }
}
