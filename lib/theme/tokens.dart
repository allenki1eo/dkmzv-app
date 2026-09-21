/// Spacing and radius scale. Screens use these instead of loose numbers so the
/// rhythm stays the same from Nyumbani to Msimamizi.
library;

class Insets {
  const Insets._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;

  /// Standard screen gutter.
  static const gutter = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Corner radii.
///
/// Tight on purpose. Large radii read as consumer-soft; the parish app wants
/// to read as a clear, plain tool, so nothing but a badge is very round.
class Radii {
  const Radii._();

  static const sm = 6.0;
  static const md = 8.0;
  static const lg = 12.0;
  static const xl = 16.0;

  /// Pills: badges and the odd chip.
  static const pill = 999.0;
}
