import 'package:flutter/material.dart';

import 'brand.dart';

/// Thème enfant, conforme à la charte :
/// titres en Nunito (700-900), texte en DM Sans, bleu nuit / sarcelle / menthe / ivoire.
final ThemeData kidsTheme = _build();

ThemeData _build() {
  final scheme = ColorScheme.fromSeed(
    seedColor: Brand.sarcelle,
    brightness: Brightness.light,
  ).copyWith(
    primary: Brand.bleuNuit,
    onPrimary: Brand.ivoire,
    secondary: Brand.sarcelle,
    onSecondary: Colors.white,
    tertiary: Brand.ambre,
    onTertiary: Brand.bleuNuit,
    surface: Colors.white,
    onSurface: Brand.ardoise,
    outlineVariant: Brand.brume,
  );

  const heading = 'Nunito';

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'DMSans',
    scaffoldBackgroundColor: Brand.ivoire,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontFamily: heading,
        fontSize: 30,
        fontWeight: FontWeight.w900,
        color: Brand.bleuNuit,
      ),
      titleLarge: TextStyle(
        fontFamily: heading,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Brand.bleuNuit,
      ),
      titleMedium: TextStyle(
        fontFamily: heading,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Brand.bleuNuit,
      ),
      bodyLarge: TextStyle(fontSize: 20, color: Brand.ardoise),
      bodyMedium: TextStyle(fontSize: 17, color: Brand.ardoise),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Brand.bleuNuit,
      titleTextStyle: TextStyle(
        fontFamily: heading,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Brand.bleuNuit,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Brand.bleuNuit,
        foregroundColor: Brand.ivoire,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: const TextStyle(
          fontFamily: heading,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Brand.sarcelle),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Brand.brume),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Brand.sarcelle, width: 2),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Brand.sarcelle,
      linearTrackColor: Brand.brume,
    ),
  );
}
