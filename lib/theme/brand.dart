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
  static const card = Color(0xFFFFFCF7);
  static const ink = Color(0xFF1B1424);
  static const muted = Color(0xFF5C5366);

  static const logoAsset = 'assets/brand/dkmzv-icon-master-1024.png';
  static const splashAsset = 'assets/brand/dkmzv-splash.png';
  static const playstoreAsset = 'assets/brand/dkmzv-playstore-512.png';

  static ThemeData theme([SeasonPalette palette = SeasonPalette.green]) {
    final cloth = palette.cloth;
    final onCloth = palette.onCloth;
    final scheme = ColorScheme.fromSeed(
      seedColor: cloth,
      primary: cloth,
      secondary: sage,
      tertiary: gold,
      surface: cream,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      appBarTheme: AppBarTheme(
        backgroundColor: cloth,
        foregroundColor: onCloth,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: onCloth),
        titleTextStyle: TextStyle(
          color: onCloth,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: gold.withValues(alpha: 0.28)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: sage.withValues(alpha: 0.22),
        selectedColor: cloth.withValues(alpha: 0.18),
        labelStyle: const TextStyle(color: ink, fontWeight: FontWeight.w500),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cloth.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cloth, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cloth,
          foregroundColor: onCloth,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cloth,
        foregroundColor: onCloth,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: cloth.withValues(alpha: 0.14),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? cloth : muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? cloth : muted);
        }),
      ),
      dividerColor: gold.withValues(alpha: 0.25),
    );
  }
}
