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
  static const canvas = Color(0xFFF5F4F2);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0F1419);
  static const muted = Color(0xFF5A6472);
  static const hairline = Color(0xFFE4E7EC);
  static const action = Color(0xFF16202B);
  static const onAction = Color(0xFFFFFFFF);

  // Neutral stack — dark.
  static const darkCanvas = Color(0xFF0B0E12);
  static const darkCard = Color(0xFF141920);
  static const darkInk = Color(0xFFE8ECF1);
  static const darkMuted = Color(0xFF949FAD);
  static const darkHairline = Color(0xFF242B35);
  static const darkAction = Color(0xFFE8ECF1);
  static const onDarkAction = Color(0xFF0B0E12);

  /// Status. Live is the one hue allowed to shout, and only on a small badge.
  static const live = Color(0xFFC0392B);

  // --- The member-facing layer ---------------------------------------------
  //
  // Deep panels carry the things a mwumini checks at a glance (their bahasha,
  // this Sunday, how the year is going). Amber is the one warm colour, used
  // for the single action that matters on a screen. Peach is its quiet tile
  // form, for schedule cards that should feel softer than white.

  /// Dark panel behind headline numbers. Teal-ink, not black.
  static const panel = Color(0xFF1D3B47);
  static const panelDeep = Color(0xFF142C36);
  static const onPanel = Color(0xFFF3F7F8);

  /// The warm action colour.
  static const amber = Color(0xFFF0A04B);
  static const amberDeep = Color(0xFFDE8B34);
  static const onAmber = Color(0xFF3A2410);

  /// Soft tile tint, paired with [amber].
  static const peach = Color(0xFFFBE6D2);
  static const peachDeep = Color(0xFFF6D6B8);
  static const onPeach = Color(0xFF4A3520);

  /// Dark-theme variants of the same two.
  static const darkPanel = Color(0xFF16232A);
  static const darkPeach = Color(0xFF2E2620);

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

  /// Dark panel for headline figures. Same colour in both themes, because it
  /// is meant to read as a solid object on the page either way.
  Color get panel =>
      canvas.computeLuminance() < 0.2 ? DkmzvBrand.darkPanel : DkmzvBrand.panel;

  Color get panelDeep => canvas.computeLuminance() < 0.2
      ? DkmzvBrand.darkPanel
      : DkmzvBrand.panelDeep;

  Color get onPanel => DkmzvBrand.onPanel;

  /// The one warm action colour.
  Color get amber => DkmzvBrand.amber;
  Color get onAmber => DkmzvBrand.onAmber;

  /// Soft tile tint. Goes dim rather than bright in the dark theme.
  Color get peach =>
      canvas.computeLuminance() < 0.2 ? DkmzvBrand.darkPeach : DkmzvBrand.peach;

  Color get onPeach =>
      canvas.computeLuminance() < 0.2 ? ink : DkmzvBrand.onPeach;

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
