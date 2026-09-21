import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'brand.dart';
import 'tokens.dart';

/// One place that turns a parish accent + brightness into the whole look.
///
/// The accent never fills a button or a card: primary actions are the neutral
/// [Surfaces.action] weight, and the accent is reserved for icons, active
/// states, links and small badges.
class AppTheme {
  static ThemeData build({
    required Color accent,
    required Brightness brightness,
    bool translucent = false,
  }) {
    final dark = brightness == Brightness.dark;
    final s = dark ? Surfaces.dark : Surfaces.light;
    final tone = accentForBrightness(accent, brightness);

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      primary: tone,
      onPrimary: _readableOn(tone),
      secondary: s.action,
      onSecondary: s.onAction,
      surface: s.canvas,
      onSurface: s.ink,
      surfaceContainerHighest: s.card,
      outline: s.hairline,
      error: DkmzvBrand.live,
    );

    final text = _textTheme(s.ink);
    final labelColour = WidgetStateTextStyle.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return TextStyle(
        fontFamily: DkmzvBrand.sans,
        color: selected ? s.onAction : s.ink,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      );
    });

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: DkmzvBrand.sans,
      // A chosen wallpaper is painted behind the navigator, so the scaffold
      // has to let it through.
      scaffoldBackgroundColor: translucent ? Colors.transparent : s.canvas,
      canvasColor: s.canvas,
      splashFactory: InkSparkle.splashFactory,
      // Pushed screens slide in from the right and drag back from the edge,
      // which is the gesture people already know from every other app on the
      // phone.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: s.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: s.ink, size: 22),
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
        margin: const EdgeInsets.only(bottom: Insets.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
          side: BorderSide(color: s.hairline),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: tone,
        titleTextStyle: text.titleSmall,
        subtitleTextStyle: text.bodySmall?.copyWith(color: s.muted),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: s.card,
        selectedColor: s.action,
        labelStyle: labelColour,
        secondaryLabelStyle: labelColour,
        checkmarkColor: s.onAction,
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.selected)
                ? Colors.transparent
                : s.hairline,
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.card,
        labelStyle: TextStyle(color: s.muted, fontFamily: DkmzvBrand.sans),
        hintStyle: TextStyle(color: s.muted, fontFamily: DkmzvBrand.sans),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: s.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: s.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: s.ink, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: s.action,
          foregroundColor: s.onAction,
          disabledBackgroundColor: s.action.withValues(alpha: 0.18),
          disabledForegroundColor: s.muted,
          elevation: 0,
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
          textStyle: const TextStyle(
            fontFamily: DkmzvBrand.sans,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: s.ink,
          side: BorderSide(color: s.hairline),
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
          textStyle: const TextStyle(
            fontFamily: DkmzvBrand.sans,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
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
        backgroundColor: s.action,
        foregroundColor: s.onAction,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.lg),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? s.action : s.card,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? s.onAction : s.ink,
          ),
          side: WidgetStateProperty.all(BorderSide(color: s.hairline)),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: DkmzvBrand.sans,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: s.card,
        surfaceTintColor: Colors.transparent,
        indicatorColor: tone.withValues(alpha: dark ? 0.22 : 0.10),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
        elevation: 0,
        height: 66,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: DkmzvBrand.sans,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? s.ink : s.muted,
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
        contentTextStyle: TextStyle(
          fontFamily: DkmzvBrand.sans,
          color: dark ? DkmzvBrand.darkInk : Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: s.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.xl),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: s.hairline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? s.onAction : s.card,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? s.action : s.hairline,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : s.muted.withValues(alpha: 0.35),
        ),
        trackOutlineWidth: const WidgetStatePropertyAll(1),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: s.action,
        thumbColor: s.action,
        inactiveTrackColor: s.hairline,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: tone),
      dividerTheme: DividerThemeData(color: s.hairline, space: Insets.xl),
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
          height: 1.12,
        );
    TextStyle sans(
      double size,
      FontWeight weight, {
      double height = 1.4,
      double spacing = 0,
    }) => TextStyle(
      fontFamily: DkmzvBrand.sans,
      color: ink,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: spacing,
    );

    return TextTheme(
      displaySmall: display(36, FontWeight.w700, -0.8),
      headlineLarge: display(30, FontWeight.w700, -0.5),
      headlineMedium: display(26, FontWeight.w600, -0.4),
      headlineSmall: display(22, FontWeight.w600, -0.3),
      titleLarge: sans(19, FontWeight.w600, height: 1.25, spacing: -0.2),
      titleMedium: sans(16, FontWeight.w600, height: 1.3, spacing: -0.1),
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
      : const Color(0xFFFFFFFF);
}
