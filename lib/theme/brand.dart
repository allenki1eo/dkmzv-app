import 'package:flutter/material.dart';

import 'liturgical.dart';

/// House colours. Vestments lock to the church year via [SeasonPalette];
/// each usharika adds its own identity accent on top of that.
class DkmzvBrand {
  static const purple = Color(0xFF2E0854);
  static const purpleDeep = Color(0xFF1C0433);
  static const gold = Color(0xFFD4AF37);
  static const cream = Color(0xFFFDF5E6);
  static const sage = Color(0xFFA2AD91);
  static const green = Color(0xFF1E4D36);
  static const red = Color(0xFF8B1E2D);
  static const canvas = Color(0xFFF7F5FA);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF17121F);
  static const muted = Color(0xFF6B6274);

  static const darkCanvas = Color(0xFF131019);
  static const darkCard = Color(0xFF1C1826);
  static const darkInk = Color(0xFFF3EFF7);
  static const darkMuted = Color(0xFF9E96AC);

  static const logoAsset = 'assets/brand/dkmzv-icon-master-1024.png';
  static const splashAsset = 'assets/brand/dkmzv-splash.png';
  static const playstoreAsset = 'assets/brand/dkmzv-playstore-512.png';

  static const sans = 'Inter';
  static const display = 'SourceSerif';

  /// Accent that stays readable on a light chrome bar (white vestment is cream).
  static Color accent(SeasonPalette palette) =>
      palette.lightBar ? purple : palette.cloth;
}

/// Reads ink/muted/card for the active brightness without a Theme lookup.
class Surfaces {
  const Surfaces._(this.ink, this.muted, this.card, this.canvas, this.hairline);

  final Color ink;
  final Color muted;
  final Color card;
  final Color canvas;
  final Color hairline;

  static const light = Surfaces._(
    DkmzvBrand.ink,
    DkmzvBrand.muted,
    DkmzvBrand.card,
    DkmzvBrand.canvas,
    Color(0x14000000),
  );

  static const dark = Surfaces._(
    DkmzvBrand.darkInk,
    DkmzvBrand.darkMuted,
    DkmzvBrand.darkCard,
    DkmzvBrand.darkCanvas,
    Color(0x1FFFFFFF),
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
