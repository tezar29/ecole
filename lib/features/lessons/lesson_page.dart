import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../core/models.dart';

/// Affiche la leçon : l'illustration du chapitre (ou un bandeau de matière si
/// elle manque), puis des blocs de texte (lisibles à voix haute) et des images distantes.
///
/// Format attendu de chapters.content :
/// {"blocks": [{"type": "text", "value": "..."}, {"type": "image", "url": "https://..."}]}
///
/// Toute la carte de texte est tactile : l'enfant peut la toucher pour
/// écouter, pas seulement le petit bouton.
class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.chapter});

  final Chapter chapter;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final FlutterTts _tts = FlutterTts();
  String? _illustration; // asset du chapitre, si l'app la fournit
  bool _poked = false; // l'illustration rebondit sous le doigt

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('fr-FR');
    _tts.setSpeechRate(0.4); // lent, adapté aux jeunes enfants
    _loadIllustration();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _loadIllustration() async {
    final code = widget.chapter.code;
    if (code == null) return;
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      if (manifest.listAssets().contains(widget.chapter.illustrationAsset) && mounted) {
        setState(() => _illustration = widget.chapter.illustrationAsset);
      }
    } catch (_) {
      // pas d'illustration : la leçon reste utilisable
    }
  }

  Future<void> _speak(String text, {String language = 'fr-FR'}) async {
    await _tts.stop();
    await _tts.setLanguage(language);
    await _tts.speak(text);
  }

  void _pokeIllustration() {
    _speak(widget.chapter.title);
    setState(() => _poked = true);
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _poked = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final blocks = ((widget.chapter.content['blocks'] as List?) ?? [])
        .cast<Map<String, dynamic>>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.chapter.title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: blocks.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          if (i == 0) {
            return _illustration != null ? _illustrationCard() : _titleCard();
          }
          final b = blocks[i - 1];
          if (b['type'] == 'image') {
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: b['url'] as String,
                fit: BoxFit.cover,
                placeholder: (_, __) => const AspectRatio(
                  aspectRatio: 2,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            );
          }
          return _textBlock(b);
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

  /// La grande image du chapitre : toucher la fait rebondir et lit le titre.
  Widget _illustrationCard() {
    return _Poke(
      poked: _poked,
      onTap: _pokeIllustration,
      label: 'Écouter le titre',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          _illustration!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  /// Bandeau de substitution quand le chapitre n'a pas d'illustration :
  /// la couleur et l'icône de la matière, avec le titre.
  Widget _titleCard() {
    final color = widget.chapter.subjectColor;
    return _Poke(
      poked: _poked,
      onTap: _pokeIllustration,
      label: 'Écouter le titre',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withAlpha(38),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withAlpha(90), width: 2),
        ),
        child: Row(
          children: [
            Icon(widget.chapter.subjectIcon, size: 56, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.chapter.title,
                style: TextStyle(
                  fontSize: 28,
                  height: 1.25,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textBlock(Map<String, dynamic> b) {
    final text = (b['value'] ?? '') as String;
    final speak = (b['speak'] ?? text) as String;
    final language = (b['lang'] ?? 'fr-FR') as String;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _speak(speak, language: language),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
        ),
      ),
    );
  }
}

/// En-tête de leçon tactile : rebondit sous le doigt et annonce le titre.
class _Poke extends StatelessWidget {
  const _Poke({
    required this.poked,
    required this.onTap,
    required this.label,
    required this.child,
  });

  final bool poked;
  final VoidCallback onTap;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: poked ? 1.05 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: child,
        ),
      ),
    );
  }
}
