import 'package:flutter/material.dart';

/// House colours.
///
/// The chrome is deliberately achromatic: a neutral slate stack carries every
/// surface, and the only filled action colour is near-black (near-white in the
/// dark theme). Hue enters in two narrow places — the usharika accent, used as
/// punctuation on icons, active states and small badges, and the vestment
/// colours below, which belong to the church year and never fill a surface
/// larger than a ribbon or a swatch.
class DkmzvBrand {
  // Neutral stack — light.
  static const canvas = Color(0xFFFAFAFA);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF000000);
  static const muted = Color(0xFF666666);
  static const hairline = Color(0xFFEAEAEA);
  static const action = Color(0xFF000000);
  static const onAction = Color(0xFFFFFFFF);

  // Neutral stack — dark.
  static const darkCanvas = Color(0xFF000000);
  static const darkCard = Color(0xFF0A0A0A);
  static const darkInk = Color(0xFFEDEDED);
  static const darkMuted = Color(0xFFA1A1A1);
  static const darkHairline = Color(0xFF242424);
  static const darkAction = Color(0xFFEDEDED);
  static const onDarkAction = Color(0xFF000000);

  /// Status. Live is the one hue allowed to shout, and only on a small badge.
  static const live = Color(0xFFC0392B);

  // --- The member-facing layer ---------------------------------------------
  //
  // Monochrome, the way a developer tool is monochrome: black on white, white
  // on black, separated by hairlines rather than shadows. Exactly one hue —
  // a single blue — and it is spent on the action that matters and nothing
  // else. Colour earns its place here by being rare.

  /// Inverted panel behind a headline figure.
  static const panel = Color(0xFF000000);
  static const panelDark = Color(0xFF0F0F0F);
  static const onPanel = Color(0xFFFFFFFF);

  /// The one hue. Used for a primary action, a live marker, a focused field.
  static const accent = Color(0xFF0070F3);
  static const accentDark = Color(0xFF3291FF);
  static const onAccent = Color(0xFFFFFFFF);

  /// A step off the page, for wells and quiet tiles.
  static const subtle = Color(0xFFF2F2F2);
  static const darkSubtle = Color(0xFF111111);

  // Vestments of the church year. Not UI chrome.
  static const clothPurple = Color(0xFF4B2E68);
  static const clothPurpleDeep = Color(0xFF321F47);
  static const clothGreen = Color(0xFF1E4D36);
  static const clothRed = Color(0xFF8B1E2D);
  static const gold = Color(0xFFB08A2E);
  static const cream = Color(0xFFFDF5E6);
  static const sage = Color(0xFFA2AD91);

  static const logoAsset = 'assets/brand/dkmzv-icon-master-1024.png';
  static const splashAsset = 'assets/brand/dkmzv-splash.png';
  static const playstoreAsset = 'assets/brand/dkmzv-playstore-512.png';

  static const sans = 'Inter';
  static const display = 'SourceSerif';
}

/// Reads the neutral stack for the active brightness without a Theme lookup.
class Surfaces {
  const Surfaces._({
    required this.ink,
    required this.muted,
    required this.card,
    required this.canvas,
    required this.hairline,
    required this.action,
    required this.onAction,
  });

  final Color ink;
  final Color muted;
  final Color card;
  final Color canvas;
  final Color hairline;

  /// Weight for the single primary action on a screen.
  final Color action;
  final Color onAction;

  /// A hair above the canvas — used for wells and unselected segments.
  Color get sunken => Color.alphaBlend(ink.withValues(alpha: 0.04), canvas);

  /// True when this is the dark stack. Cheaper and clearer than comparing
  /// luminance at every call site.
  bool get isDark => canvas == DkmzvBrand.darkCanvas;

  /// Inverted panel for a headline figure: black on the light theme, a hair
  /// off black on the dark one so its edge still reads.
  Color get panel => isDark ? DkmzvBrand.panelDark : DkmzvBrand.panel;

  Color get onPanel => isDark ? DkmzvBrand.darkInk : DkmzvBrand.onPanel;

  /// The one hue in the app.
  Color get accent => isDark ? DkmzvBrand.accentDark : DkmzvBrand.accent;
  Color get onAccent => DkmzvBrand.onAccent;

  /// A step off the page: wells, quiet tiles, unselected segments.
  Color get subtle => isDark ? DkmzvBrand.darkSubtle : DkmzvBrand.subtle;

  static const light = Surfaces._(
    ink: DkmzvBrand.ink,
    muted: DkmzvBrand.muted,
    card: DkmzvBrand.card,
    canvas: DkmzvBrand.canvas,
    hairline: DkmzvBrand.hairline,
    action: DkmzvBrand.action,
    onAction: DkmzvBrand.onAction,
  );

  static const dark = Surfaces._(
    ink: DkmzvBrand.darkInk,
    muted: DkmzvBrand.darkMuted,
    card: DkmzvBrand.darkCard,
    canvas: DkmzvBrand.darkCanvas,
    hairline: DkmzvBrand.darkHairline,
    action: DkmzvBrand.darkAction,
    onAction: DkmzvBrand.onDarkAction,
  );

  static Surfaces of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

/// Lifts a parish accent until it reads on a dark surface.
Color accentForBrightness(Color accent, Brightness brightness) {
  if (brightness == Brightness.light) return accent;
  final hsl = HSLColor.fromColor(accent);
  return hsl
      .withLightness(hsl.lightness < 0.62 ? 0.72 : hsl.lightness)
      .withSaturation((hsl.saturation * 0.85).clamp(0.25, 0.9))
      .toColor();
}
