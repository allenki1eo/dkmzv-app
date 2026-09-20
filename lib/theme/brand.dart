import 'package:flutter/material.dart';

/// Liturgical palette. Purple is for chrome/splash **fields** only —
/// never the adaptive launcher background (that plate is white).
class DkmzvBrand {
  static const purple = Color(0xFF2E0854);
  static const purpleDeep = Color(0xFF1C0433);
  static const green = Color(0xFF2E6B4F);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFF7F3EA);
  static const card = Color(0xFFFFFCF7);
  static const ink = Color(0xFF1B1424);
  static const muted = Color(0xFF5C5366);

  static const logoAsset = 'assets/brand/dkmzv-icon-master-1024.png';
  static const splashAsset = 'assets/brand/dkmzv-splash.png';
  static const playstoreAsset = 'assets/brand/dkmzv-playstore-512.png';

  static ThemeData theme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: purple,
      primary: purple,
      secondary: green,
      tertiary: gold,
      surface: cream,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: purple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: purple.withValues(alpha: 0.08)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: purple.withValues(alpha: 0.08),
        selectedColor: purple.withValues(alpha: 0.16),
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
          borderSide: BorderSide(color: purple.withValues(alpha: 0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: purple, width: 1.6),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: purple,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: purple,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
      ),
      dividerColor: purple.withValues(alpha: 0.1),
    );
  }
}
