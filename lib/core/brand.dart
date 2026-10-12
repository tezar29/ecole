import 'package:flutter/material.dart';

/// Nom affiché dans l'app. La charte utilise « École des Érables » comme exemple
/// fictif : remplace-le par le vrai nom avant diffusion.
const String kAppName = 'Mon École';

/// Signature proposée dans la charte (à valider).
const String kSlogan = 'Apprendre · Grandir · Explorer';

/// Palette officielle (charte graphique v1.0).
class Brand {
  static const Color bleuNuit = Color(0xFF102A56); // logo, titres, contrastes
  static const Color sarcelle = Color(0xFF16A6A4); // accents, repères
  static const Color menthe = Color(0xFF8ADBBE); // aplats doux
  static const Color ivoire = Color(0xFFFFF4D6); // fonds chaleureux
  static const Color ambre = Color(0xFFF4A62A); // accent ponctuel (< 5 %)
  static const Color ardoise = Color(0xFF27384E); // texte courant
  static const Color brume = Color(0xFFD7E2E8); // filets, séparateurs

  // Retours d'exercice (hors charte, volontairement doux)
  static const Color wrongSoft = Color(0xFFF4B6B0);
}
