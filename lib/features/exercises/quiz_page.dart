import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../core/brand.dart';
import '../../core/models.dart';
import '../../core/providers.dart';
import '../../shared/mascot.dart';
import 'exercise_widgets.dart';

/// Quiz d'un chapitre. Types gérés : qcm, vrai_faux, association, saisie, glisser_deposer.
///
/// Formats JSON (colonnes question / answer) :
/// - qcm, vrai_faux : {"text","options":[...]}            / {"correct": index, "explanation"}
/// - association    : {"text","pairs":[{"left","right"}]}  / {"explanation"}
/// - saisie         : {"text","keyboard":"number|text"}    / {"accepted":[...],"explanation"}
/// - glisser_deposer: {"text","items":[...désordre]}       / {"order":[...],"explanation"}
class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key, required this.chapter});

  final Chapter chapter;

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  final FlutterTts _tts = FlutterTts();
  int _index = 0;
  int _score = 0;
  int _total = 0;
  bool _answered = false;
  bool? _lastCorrect;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('fr-FR');
    _tts.setSpeechRate(0.4);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak(String text, {String language = 'fr-FR'}) async {
    await _tts.stop();
    await _tts.setLanguage(language);
    await _tts.speak(text);
  }

  int get _stars {
    final ratio = _total == 0 ? 0 : _score / _total;
    if (ratio >= 0.9) return 3;
    if (ratio >= 0.6) return 2;
    if (ratio >= 0.3) return 1;
    return 0;
  }

  void _onDone(bool correct) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _lastCorrect = correct;
      if (correct) _score++;
    });
  }

  /// Exercice non géré par cette version de l'app : on passe sans point.
  void _skip() => setState(() {
        _answered = true;
        _lastCorrect = null;
      });

  Future<void> _next() async {
    if (_index + 1 >= _total) {
      setState(() => _finished = true);
      await _saveProgress();
    } else {
      setState(() {
        _index++;
        _answered = false;
        _lastCorrect = null;
      });
    }
  }

  Future<void> _saveProgress() async {
    final child = ref.read(selectedChildProvider);
    if (child == null) return;
    final client = ref.read(supabaseProvider);
    try {
      final existing = await client
          .from('progress')
          .select('stars')
          .eq('child_id', child.id)
          .eq('chapter_id', widget.chapter.id)
          .maybeSingle();
      final best = max(_stars, (existing?['stars'] as int?) ?? 0);
      final now = DateTime.now().toIso8601String();
      await client.from('progress').upsert(
        {
          'child_id': child.id,
          'chapter_id': widget.chapter.id,
          'stars': best,
          'score': _score,
          'completed_at': now,
          'updated_at': now,
        },
        onConflict: 'child_id,chapter_id',
      );
      ref.invalidate(progressProvider(child.id));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Progression non enregistrée : $e')),
      );
    }
  }

  void _restart() => setState(() {
        _index = 0;
        _score = 0;
        _answered = false;
        _lastCorrect = null;
        _finished = false;
      });

  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(exercisesProvider(widget.chapter.id));

    return Scaffold(
      appBar: AppBar(title: Text(widget.chapter.title)),
      body: exercises.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) {
          _total = list.length;
          if (list.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Mascot(kind: MascotKind.logo, height: 120),
                  SizedBox(height: 12),
                  Text(
                    'Pas encore d\'exercices ici',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          }
          return _finished ? _result() : _question(list);
        },
      ),
    );
  }

  Widget _exercise(Exercise e) {
    final key = ValueKey(e.id);
    final q = e.question;
    final a = e.answer;

    switch (e.type) {
      case 'qcm':
      case 'vrai_faux':
        return QcmExercise(
          key: key,
          options: ((q['options'] as List?) ?? []).cast<String>(),
          correct: a['correct'] as int,
          onDone: _onDone,
        );
      case 'association':
        final pairs = ((q['pairs'] as List?) ?? []).map((p) {
          final m = (p as Map).cast<String, dynamic>();
          return (left: m['left'].toString(), right: m['right'].toString());
        }).toList();
        return AssociationExercise(key: key, pairs: pairs, onDone: _onDone);
      case 'saisie':
        return SaisieExercise(
          key: key,
          accepted: ((a['accepted'] as List?) ?? []).map((x) => x.toString()).toList(),
          numeric: q['keyboard'] == 'number',
          onDone: _onDone,
        );
      case 'glisser_deposer':
        return OrderExercise(
          key: key,
          items: ((q['items'] as List?) ?? []).map((x) => x.toString()).toList(),
          order: ((a['order'] as List?) ?? []).map((x) => x.toString()).toList(),
          onDone: _onDone,
        );
      default:
        return Center(
          child: FilledButton(
            onPressed: _skip,
            child: const Text('Cet exercice arrive bientôt · Passer'),
          ),
        );
    }
  }

  Widget _question(List<Exercise> list) {
    final e = list[_index];
    final text = (e.question['text'] ?? '') as String;
    final language = (e.question['lang'] ?? 'fr-FR') as String;
    final explanation = e.answer['explanation'] as String?;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: _index / list.length,
            minHeight: 12,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Brand.bleuNuit,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  iconSize: 36,
                  tooltip: 'Écouter',
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => _speak(text, language: language),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _exercise(e)),
          if (_answered) ...[
            if (_lastCorrect != null || explanation != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  [
                    if (_lastCorrect == true) 'Bravo !',
                    if (_lastCorrect == false) 'Pas tout à fait.',
                    if (explanation != null) explanation,
                  ].join(' '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Brand.bleuNuit,
                  ),
                ),
              ),
            FilledButton(
              onPressed: _next,
              child: Text(
                _index + 1 == list.length ? 'Voir mon résultat' : 'Suivant',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _result() {
    final stars = _stars;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Mascot(height: 220),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var s = 1; s <= 3; s++)
                Icon(
                  s <= stars ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 72,
                  color: Brand.ambre,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            stars == 3
                ? 'Super !'
                : stars > 0
                    ? 'Bien joué !'
                    : 'Courage, on réessaie !',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '$_score / $_total',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Brand.ardoise,
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(onPressed: _restart, child: const Text('Recommencer')),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Brand.sarcelle,
              foregroundColor: Colors.white,
            ),
            onPressed: () => context.pop(),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }
}
