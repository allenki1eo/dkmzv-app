import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/brand.dart';
import '../theme/tokens.dart';
import 'common.dart';

/// The member-facing kit.
///
/// Monochrome and flat: surfaces are separated by a hairline, never a shadow;
/// corners are tight; the one blue is spent on the single action that matters
/// on a screen and nowhere else.

/// Inverted panel behind a headline figure — black on the light theme, near
/// black on the dark one. Used where a number is the subject of the screen.
class HeroPanel extends StatelessWidget {
  const HeroPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Insets.lg + 4),
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final panel = Container(
      decoration: BoxDecoration(
        color: s.panel,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: s.isDark ? Border.all(color: s.hairline) : null,
      ),
      padding: padding,
      child: child,
    );
    if (onTap == null) return panel;
    return Pressable(onTap: onTap, child: panel);
  }
}

/// A thin progress arc with a figure in the middle.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.label,
    this.size = 64,
    this.track,
    this.fill,
    this.labelColor,
  });

  final double value;
  final String label;
  final double size;
  final Color? track;
  final Color? fill;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) => CustomPaint(
          painter: _RingPainter(
            value: t,
            track: track ?? s.onPanel.withValues(alpha: 0.16),
            fill: fill ?? s.onPanel,
            stroke: 3,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: labelColor ?? s.onPanel,
                fontSize: size * 0.22,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.track,
    required this.fill,
    required this.stroke,
  });

  final double value;
  final Color track;
  final Color fill;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = (Offset.zero & size).center;
    final radius = (math.min(size.width, size.height) - stroke) / 2;

    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    if (value <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      Paint()
        ..color = fill
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.fill != fill || old.track != track;
}

/// One figure in a [StatStrip].
class Stat {
  const Stat({required this.value, required this.label});
  final String value;
  final String label;
}

/// Figures side by side, divided by hairlines.
class StatStrip extends StatelessWidget {
  const StatStrip({super.key, required this.stats, this.onPanel = true});

  final List<Stat> stats;

  /// True when the strip sits on an inverted panel.
  final bool onPanel;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final strong = onPanel ? s.onPanel : s.ink;
    final quiet = onPanel ? s.onPanel.withValues(alpha: 0.6) : s.muted;
    final rule = onPanel ? s.onPanel.withValues(alpha: 0.16) : s.hairline;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) Container(width: 1, height: 30, color: rule),
          Expanded(
            child: Column(
              children: [
                FittedBox(
                  child: Text(
                    stats[i].value,
                    style: TextStyle(
                      color: strong,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  stats[i].label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: quiet,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// How a [FlatButton] is weighted.
enum ButtonTone {
  /// Solid, inverted against the page. The one action that matters.
  primary,

  /// Hairline border, transparent fill.
  secondary,

  /// Solid blue. Reserved for the moment colour genuinely helps.
  accent,
}

/// A flat rectangular button with a tight radius. No gradient, no shadow.
class FlatButton extends StatelessWidget {
  const FlatButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = ButtonTone.primary,
    this.compact = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonTone tone;
  final bool compact;

  /// False keeps the button to its content width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final enabled = onPressed != null;

    late final Color bg;
    late final Color fg;
    late final Color? border;
    switch (tone) {
      case ButtonTone.primary:
        bg = enabled ? s.action : s.subtle;
        fg = enabled ? s.onAction : s.muted;
        border = null;
      case ButtonTone.secondary:
        bg = Colors.transparent;
        fg = enabled ? s.ink : s.muted;
        border = s.hairline;
      case ButtonTone.accent:
        bg = enabled ? s.accent : s.subtle;
        fg = enabled ? s.onAccent : s.muted;
        border = null;
    }

    return Pressable(
      onTap: onPressed,
      scale: 0.985,
      child: Container(
        height: compact ? 36 : 44,
        width: expand ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? Insets.md : Insets.lg,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Radii.md),
          border: border == null ? null : Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: compact ? 15 : 16, color: fg),
              const SizedBox(width: Insets.sm),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: fg,
                  fontSize: compact ? 13 : 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// How a [SoftTile] is filled.
enum SoftTone { plain, subtle, dark }

/// A bordered tile. The workhorse of the grids and the timeline.
class SoftTile extends StatelessWidget {
  const SoftTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.tone = SoftTone.plain,
    this.height,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final SoftTone tone;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final (bg, fg, quiet) = switch (tone) {
      SoftTone.plain => (s.card, s.ink, s.muted),
      SoftTone.subtle => (s.subtle, s.ink, s.muted),
      SoftTone.dark => (s.panel, s.onPanel, s.onPanel.withValues(alpha: 0.6)),
    };

    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(
            color: tone == SoftTone.dark ? s.panel : s.hairline,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: Icon(icon, size: 18, color: fg),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    letterSpacing: -0.1,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: quiet, fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A row on the day's list: the hour in the margin, the event beside it.
class TimelineRow extends StatelessWidget {
  const TimelineRow({
    super.key,
    required this.time,
    required this.title,
    this.subtitle,
    this.onTap,
    this.highlight = false,
  });

  final String time;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  /// Marks the next thing due.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Padding(
            padding: const EdgeInsets.only(top: Insets.md + 2),
            child: Text(
              time,
              style: TextStyle(
                color: highlight ? s.ink : s.muted,
                fontSize: 12,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Insets.sm),
            child: SoftTile(
              title: title,
              subtitle: subtitle,
              onTap: onTap,
              tone: highlight ? SoftTone.subtle : SoftTone.plain,
            ),
          ),
        ),
      ],
    );
  }
}

/// Overlapping round initials. The app holds no member photographs.
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.initials,
    this.size = 24,
    this.max = 3,
  });

  final List<String> initials;
  final double size;
  final int max;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final shown = initials.take(max).toList();
    final extra = initials.length - shown.length;
    if (shown.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: size,
      width:
          size +
          (shown.length - 1) * size * 0.66 +
          (extra > 0 ? size * 0.66 : 0),
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * size * 0.66,
              child: _Bubble(text: shown[i], size: size, color: s.panel),
            ),
          if (extra > 0)
            Positioned(
              left: shown.length * size * 0.66,
              child: _Bubble(text: '+$extra', size: size, color: s.muted),
            ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.size, required this.color});

  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: s.card, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: s.isDark && color == s.panel ? s.ink : s.onPanel,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Page heading. Tight, large, plain — the whole line in one weight.
class DisplayHeading extends StatelessWidget {
  const DisplayHeading({super.key, required this.text, this.quiet});

  final String text;

  /// A second line under the heading, in the muted weight.
  final String? quiet;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: s.ink,
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.0,
          ),
        ),
        if (quiet != null && quiet!.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            quiet!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: s.muted, fontSize: 14, letterSpacing: -0.1),
          ),
        ],
      ],
    );
  }
}

/// Small uppercase label above a figure or a group.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color ?? s.muted,
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
      ),
    );
  }
}

/// Initials for an avatar bubble, from a person's name.
String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final one = parts.first;
    return one.substring(0, one.length >= 2 ? 2 : 1).toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
