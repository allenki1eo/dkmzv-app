import 'package:flutter/material.dart';

import 'brand.dart';

/// One place that turns a parish accent + brightness into the whole look.
class AppTheme {
  static ThemeData build({
    required Color accent,
    required Brightness brightness,
  }) {
    final dark = brightness == Brightness.dark;
    final s = dark ? Surfaces.dark : Surfaces.light;
    final tone = accentForBrightness(accent, brightness);
    final onAccent = _readableOn(tone);

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      primary: tone,
      onPrimary: onAccent,
      secondary: DkmzvBrand.sage,
      tertiary: DkmzvBrand.gold,
      surface: s.canvas,
      onSurface: s.ink,
    );

    final text = _textTheme(s.ink);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: DkmzvBrand.sans,
      scaffoldBackgroundColor: s.canvas,
      canvasColor: s.canvas,
      splashFactory: InkSparkle.splashFactory,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: s.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: s.ink),
        titleTextStyle: TextStyle(
          fontFamily: DkmzvBrand.sans,
          color: s.ink,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: s.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: s.hairline),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: tone,
        titleTextStyle: text.titleSmall,
        subtitleTextStyle: text.bodySmall?.copyWith(color: s.muted),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: s.card,
        selectedColor: tone.withValues(alpha: dark ? 0.24 : 0.12),
        labelStyle: TextStyle(
          fontFamily: DkmzvBrand.sans,
          color: s.ink,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        side: BorderSide(color: s.hairline),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.card,
        labelStyle: TextStyle(color: s.muted, fontFamily: DkmzvBrand.sans),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: s.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: s.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: tone, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tone,
          foregroundColor: onAccent,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          textStyle: const TextStyle(
            fontFamily: DkmzvBrand.sans,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tone,
          side: BorderSide(color: tone.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: DkmzvBrand.sans,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tone,
          textStyle: const TextStyle(
            fontFamily: DkmzvBrand.sans,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tone,
        foregroundColor: onAccent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: s.card,
        surfaceTintColor: Colors.transparent,
        indicatorColor: tone.withValues(alpha: dark ? 0.26 : 0.12),
        elevation: 0,
        height: 66,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: DkmzvBrand.sans,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? tone : s.muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? tone : s.muted, size: 22);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? DkmzvBrand.darkCard : DkmzvBrand.ink,
        contentTextStyle: const TextStyle(
            fontFamily: DkmzvBrand.sans, color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: s.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.card,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? onAccent : null),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? tone : null),
      ),
      dividerTheme: DividerThemeData(color: s.hairline, space: 24),
      dividerColor: s.hairline,
    );
  }

  static TextTheme _textTheme(Color ink) {
    TextStyle display(double size, FontWeight weight, double spacing) =>
        TextStyle(
          fontFamily: DkmzvBrand.display,
          color: ink,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: spacing,
          height: 1.14,
        );
    TextStyle sans(double size, FontWeight weight,
            {double height = 1.4, double spacing = 0}) =>
        TextStyle(
          fontFamily: DkmzvBrand.sans,
          color: ink,
          fontSize: size,
          fontWeight: weight,
          height: height,
          letterSpacing: spacing,
        );

    return TextTheme(
      displaySmall: display(34, FontWeight.w700, -0.6),
      headlineLarge: display(30, FontWeight.w700, -0.5),
      headlineMedium: display(26, FontWeight.w600, -0.4),
      headlineSmall: display(22, FontWeight.w600, -0.3),
      titleLarge: sans(19, FontWeight.w600, height: 1.25, spacing: -0.2),
      titleMedium: sans(16, FontWeight.w600, height: 1.3),
      titleSmall: sans(15, FontWeight.w600, height: 1.3),
      bodyLarge: sans(15.5, FontWeight.w400, height: 1.5),
      bodyMedium: sans(14.5, FontWeight.w400, height: 1.5),
      bodySmall: sans(13, FontWeight.w400, height: 1.45),
      labelLarge: sans(14, FontWeight.w600, height: 1.2),
      labelMedium: sans(12.5, FontWeight.w600, height: 1.2),
      labelSmall: sans(11.5, FontWeight.w600, height: 1.2, spacing: 0.2),
    );
  }

  static Color _readableOn(Color background) =>
      background.computeLuminance() > 0.55
          ? DkmzvBrand.ink
          : const Color(0xFFFFFBF5);
}
