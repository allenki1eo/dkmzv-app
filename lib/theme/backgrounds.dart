import 'package:flutter/material.dart';

/// Optional wallpaper a member can pick. Kept faint so text stays readable.
class AppBackground {
  const AppBackground({
    required this.id,
    required this.sw,
    required this.en,
    required this.asset,
    required this.preferDark,
  });

  final String id;
  final String sw;
  final String en;
  final String? asset;
  final bool preferDark;

  String label(bool isSw) => isSw ? sw : en;

  static const none = AppBackground(
    id: 'none',
    sw: 'Sadifu',
    en: 'Plain',
    asset: null,
    preferDark: false,
  );

  static const all = <AppBackground>[
    none,
    AppBackground(
      id: 'maua',
      sw: 'Maua',
      en: 'Flowers',
      asset: 'assets/backgrounds/maua.webp',
      preferDark: false,
    ),
    AppBackground(
      id: 'mapambazuko',
      sw: 'Mapambazuko',
      en: 'Sunrise',
      asset: 'assets/backgrounds/mapambazuko.webp',
      preferDark: false,
    ),
    AppBackground(
      id: 'kitenge',
      sw: 'Kitenge',
      en: 'Kitenge',
      asset: 'assets/backgrounds/kitenge.webp',
      preferDark: false,
    ),
    AppBackground(
      id: 'usiku',
      sw: 'Usiku',
      en: 'Night',
      asset: 'assets/backgrounds/usiku.webp',
      preferDark: true,
    ),
  ];

  static AppBackground byId(String? id) {
    for (final b in all) {
      if (b.id == id) return b;
    }
    return none;
  }
}

/// Paints the chosen wallpaper behind a screen with a scrim for legibility.
class BackgroundCanvas extends StatelessWidget {
  const BackgroundCanvas({
    super.key,
    required this.background,
    required this.child,
  });

  final AppBackground background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final asset = background.asset;
    if (asset == null) return child;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final canvas = Theme.of(context).scaffoldBackgroundColor;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(asset, fit: BoxFit.cover, alignment: Alignment.topCenter),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                canvas.withValues(alpha: dark ? 0.88 : 0.86),
                canvas.withValues(alpha: dark ? 0.94 : 0.93),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
