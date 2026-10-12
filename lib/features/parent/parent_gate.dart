import 'dart:math';

import 'package:flutter/material.dart';

/// Petit calcul à résoudre avant d'entrer dans l'espace parent
/// (un enfant de CM2 peut le résoudre, mais pas un enfant de SIL ou CP).
/// Retourne true si le calcul est réussi.
Future<bool> showParentGate(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => const _ParentGateDialog(),
  );
  return ok ?? false;
}

class _ParentGateDialog extends StatefulWidget {
  const _ParentGateDialog();

  @override
  State<_ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<_ParentGateDialog> {
  final _rnd = Random();
  late final int _a = 6 + _rnd.nextInt(7); // 6 à 12
  late final int _b = 6 + _rnd.nextInt(7);
  final _ctrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    if (int.tryParse(_ctrl.text.trim()) == _a * _b) {
      Navigator.pop(context, true);
    } else {
      setState(() => _error = 'Ce n\'est pas ça, réessaie.');
      _ctrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Espace parent'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Pour entrer, résous ce calcul :'),
          const SizedBox(height: 12),
          Text(
            '$_a × $_b = ?',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            autofocus: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(errorText: _error),
            onSubmitted: (_) => _check(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(120, 48)),
          onPressed: _check,
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
