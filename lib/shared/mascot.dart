import 'package:flutter/material.dart';

enum MascotKind {
  /// Logo principal (tortue minimaliste) : connexion, icônes, états vides.
  logo,

  /// Mascotte 3D expressive : accueil, félicitations, accompagnement.
  expressive,
}

/// Affiche la tortue en respectant la charte : jamais étirée ni recadrée
/// (on fixe seulement la hauteur, la largeur suit), aucun effet ni ombre.
class Mascot extends StatelessWidget {
  const Mascot({super.key, this.kind = MascotKind.expressive, this.height = 120});

  final MascotKind kind;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kind == MascotKind.logo
          ? 'assets/images/logo_tortue.png'
          : 'assets/images/mascotte_tortue_3d.png',
      height: height,
      fit: BoxFit.contain,
      semanticLabel: 'Tortue mascotte',
    );
  }
}
