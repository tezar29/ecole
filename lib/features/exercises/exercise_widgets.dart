import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/brand.dart';

/// Appelé UNE fois, quand l'élève a terminé l'exercice.
typedef DoneCallback = void Function(bool correct);

/// Minuscules, sans accents, espaces nettoyés : « Sept » == « sept ».
String normalizeAnswer(String s) {
  const from = 'àâäáãçéèêëíìîïñóòôöõúùûüýÿ';
  const to = 'aaaaaceeeeiiiinooooouuuuyy';
  var out = s.trim().toLowerCase().replaceAll('œ', 'oe');
  for (var i = 0; i < from.length; i++) {
    out = out.replaceAll(from[i], to[i]);
  }
  return out.replaceAll(RegExp(r'\s+'), ' ');
}

/// Grosse tuile tactile utilisée par tous les exercices.
class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
    this.fontSize = 26,
    this.verticalPadding = 20,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;
  final double fontSize;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 16),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: Brand.bleuNuit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QCM et vrai/faux
// ---------------------------------------------------------------------------
class QcmExercise extends StatefulWidget {
  const QcmExercise({
    super.key,
    required this.options,
    required this.correct,
    required this.onDone,
  });

  final List<String> options;
  final int correct;
  final DoneCallback onDone;

  @override
  State<QcmExercise> createState() => _QcmExerciseState();
}

class _QcmExerciseState extends State<QcmExercise> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < widget.options.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ChoiceTile(
              label: widget.options[i],
              color: _selected == null
                  ? Colors.white
                  : i == widget.correct
                      ? Brand.menthe
                      : i == _selected
                          ? Brand.wrongSoft
                          : Colors.white,
              onTap: () {
                if (_selected != null) return;
                setState(() => _selected = i);
                widget.onDone(i == widget.correct);
              },
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Association : on touche un élément à gauche puis son correspondant à droite
// ---------------------------------------------------------------------------
class AssociationExercise extends StatefulWidget {
  const AssociationExercise({super.key, required this.pairs, required this.onDone});

  final List<({String left, String right})> pairs;
  final DoneCallback onDone;

  @override
  State<AssociationExercise> createState() => _AssociationExerciseState();
}

class _AssociationExerciseState extends State<AssociationExercise> {
  late final List<int> _rightOrder =
      List<int>.generate(widget.pairs.length, (i) => i)..shuffle(Random());
  final Set<int> _matched = {};
  int? _selectedLeft;
  int? _wrongRight;
  int _mistakes = 0;

  bool get _done => _matched.length == widget.pairs.length;

  void _tapLeft(int i) {
    if (_done || _matched.contains(i)) return;
    setState(() => _selectedLeft = i);
  }

  void _tapRight(int r) {
    if (_done || _matched.contains(r) || _selectedLeft == null) return;
    if (_selectedLeft == r) {
      setState(() {
        _matched.add(r);
        _selectedLeft = null;
      });
      if (_done) widget.onDone(_mistakes == 0);
    } else {
      setState(() {
        _mistakes++;
        _wrongRight = r;
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _wrongRight = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                for (var i = 0; i < widget.pairs.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ChoiceTile(
                      label: widget.pairs[i].left,
                      fontSize: 24,
                      verticalPadding: 18,
                      color: _matched.contains(i)
                          ? Brand.menthe
                          : _selectedLeft == i
                              ? Brand.sarcelle.withAlpha(120)
                              : Colors.white,
                      onTap: () => _tapLeft(i),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                for (final r in _rightOrder)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ChoiceTile(
                      label: widget.pairs[r].right,
                      fontSize: 24,
                      verticalPadding: 18,
                      color: _matched.contains(r)
                          ? Brand.menthe
                          : _wrongRight == r
                              ? Brand.wrongSoft
                              : Colors.white,
                      onTap: () => _tapRight(r),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Saisie : l'élève écrit la réponse
// ---------------------------------------------------------------------------
class SaisieExercise extends StatefulWidget {
  const SaisieExercise({
    super.key,
    required this.accepted,
    required this.numeric,
    required this.onDone,
  });

  final List<String> accepted;
  final bool numeric;
  final DoneCallback onDone;

  @override
  State<SaisieExercise> createState() => _SaisieExerciseState();
}

class _SaisieExerciseState extends State<SaisieExercise> {
  final _ctrl = TextEditingController();
  bool? _ok;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_ok != null || _ctrl.text.trim().isEmpty) return;
    final given = normalizeAnswer(_ctrl.text);
    final ok = widget.accepted.map(normalizeAnswer).contains(given);
    FocusScope.of(context).unfocus();
    setState(() => _ok = ok);
    widget.onDone(ok);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _ctrl,
            enabled: _ok == null,
            textAlign: TextAlign.center,
            keyboardType:
                widget.numeric ? TextInputType.number : TextInputType.text,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Brand.bleuNuit,
            ),
            decoration: InputDecoration(
              hintText: 'Ta réponse',
              fillColor: _ok == null
                  ? Colors.white
                  : _ok!
                      ? Brand.menthe
                      : Brand.wrongSoft,
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          if (_ok == null)
            FilledButton(onPressed: _submit, child: const Text('Valider'))
          else if (!_ok!)
            Text(
              'La réponse était : ${widget.accepted.first}',
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Glisser-déposer : ranger des cartes dans l'ordre (le toucher marche aussi)
// ---------------------------------------------------------------------------
class OrderExercise extends StatefulWidget {
  const OrderExercise({
    super.key,
    required this.items,
    required this.order,
    required this.onDone,
  });

  /// Cartes affichées (dans le désordre).
  final List<String> items;

  /// Ordre attendu.
  final List<String> order;
  final DoneCallback onDone;

  @override
  State<OrderExercise> createState() => _OrderExerciseState();
}

class _OrderExerciseState extends State<OrderExercise> {
  late final List<int?> _slots = List<int?>.filled(widget.items.length, null);
  bool? _ok;

  bool get _checked => _ok != null;
  bool get _allFilled => _slots.every((s) => s != null);

  void _place(int slot, int item) {
    if (_checked) return;
    setState(() {
      final prev = _slots.indexOf(item);
      if (prev != -1) _slots[prev] = null;
      _slots[slot] = item;
    });
  }

  void _placeInFirstEmpty(int item) {
    final i = _slots.indexOf(null);
    if (i != -1) _place(i, item);
  }

  void _remove(int slot) {
    if (_checked) return;
    setState(() => _slots[slot] = null);
  }

  void _check() {
    final given = [for (final s in _slots) widget.items[s!]];
    var ok = given.length == widget.order.length;
    for (var i = 0; ok && i < given.length; i++) {
      ok = given[i] == widget.order[i];
    }
    setState(() => _ok = ok);
    widget.onDone(ok);
  }

  Widget _chip(String label, {Color? color, double opacity = 1}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        constraints: const BoxConstraints(minWidth: 76, minHeight: 76),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Brand.bleuNuit,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placed = _slots.whereType<int>().toSet();

    return SingleChildScrollView(
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (var s = 0; s < _slots.length; s++)
                DragTarget<int>(
                  onAcceptWithDetails: (d) => _place(s, d.data),
                  builder: (context, candidates, _) {
                    final item = _slots[s];
                    final base = item == null
                        ? (candidates.isNotEmpty
                            ? Brand.menthe.withAlpha(150)
                            : Brand.brume)
                        : _checked
                            ? (_ok! ? Brand.menthe : Brand.wrongSoft)
                            : Colors.white;
                    return GestureDetector(
                      onTap: item == null ? null : () => _remove(s),
                      child: _chip(
                        item == null ? '${s + 1}' : widget.items[item],
                        color: base,
                        opacity: item == null ? 0.8 : 1,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Glisse les cartes ou touche-les',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < widget.items.length; i++)
                if (!placed.contains(i))
                  Draggable<int>(
                    data: i,
                    feedback: Material(
                      color: Colors.transparent,
                      child: _chip(widget.items[i]),
                    ),
                    childWhenDragging:
                        _chip(widget.items[i], opacity: 0.3),
                    child: GestureDetector(
                      onTap: () => _placeInFirstEmpty(i),
                      child: _chip(widget.items[i]),
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 24),
          if (!_checked && _allFilled)
            FilledButton(onPressed: _check, child: const Text('Vérifier')),
        ],
      ),
    );
  }
}
