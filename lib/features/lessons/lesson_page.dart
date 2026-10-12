import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../core/models.dart';

/// Affiche la leçon : blocs de texte (lisibles à voix haute) et images.
///
/// Format attendu de chapters.content :
/// {"blocks": [{"type": "text", "value": "..."}, {"type": "image", "url": "https://..."}]}
class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.chapter});

  final Chapter chapter;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('fr-FR');
    _tts.setSpeechRate(0.4); // lent, adapté aux jeunes enfants
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

  @override
  Widget build(BuildContext context) {
    final blocks = ((widget.chapter.content['blocks'] as List?) ?? [])
        .cast<Map<String, dynamic>>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.chapter.title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: blocks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final b = blocks[i];
          if (b['type'] == 'image') {
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                b['url'] as String,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            );
          }
          final text = (b['value'] ?? '') as String;
          final speak = (b['speak'] ?? text) as String;
          final language = (b['lang'] ?? 'fr-FR') as String;
          return Container(
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
                    style: const TextStyle(fontSize: 26, height: 1.4),
                  ),
                ),
                IconButton.filledTonal(
                  iconSize: 36,
                  tooltip: 'Écouter',
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => _speak(speak, language: language),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () =>
                context.pushReplacement('/quiz', extra: widget.chapter),
            child: const Text('Je m\'entraîne ! ✏️'),
          ),
        ),
      ),
    );
  }
}
