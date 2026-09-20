import 'package:flutter/material.dart';

import 'liturgical.dart';

/// House colours. Vestments lock to the church year via [SeasonPalette].
class DkmzvBrand {
  static const purple = Color(0xFF2E0854);
  static const purpleDeep = Color(0xFF1C0433);
  static const gold = Color(0xFFD4AF37);
  static const cream = Color(0xFFFDF5E6);
  static const sage = Color(0xFFA2AD91);
  static const green = Color(0xFF1E4D36);
  static const red = Color(0xFF8B1E2D);
  static const canvas = Color(0xFFF6F3FA);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1B1424);
  static const muted = Color(0xFF6B6274);

  static const logoAsset = 'assets/brand/dkmzv-icon-master-1024.png';
  static const splashAsset = 'assets/brand/dkmzv-splash.png';
  static const playstoreAsset = 'assets/brand/dkmzv-playstore-512.png';

  /// Accent that stays readable on a white chrome bar (white vestment is cream).
  static Color accent(SeasonPalette palette) =>
      palette.lightBar ? purple : palette.cloth;

  static ThemeData theme([SeasonPalette palette = SeasonPalette.green]) {
    final onCloth = palette.onCloth;
    final accent = DkmzvBrand.accent(palette);
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      primary: accent,
      secondary: sage,
      tertiary: gold,
      surface: canvas,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ink),
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0x14000000)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: accent.withValues(alpha: 0.12),
        labelStyle: const TextStyle(color: ink, fontWeight: FontWeight.w500),
        side: const BorderSide(color: Color(0x14000000)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x1A000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onCloth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: onCloth,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: accent.withValues(alpha: 0.12),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? accent : muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? accent : muted, size: 22);
        }),
      ),
      dividerColor: const Color(0x14000000),
      textTheme: ThemeData(useMaterial3: true).textTheme.apply(
            bodyColor: ink,
            displayColor: ink,
          ),
    );
  }
}
