import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/brand.dart';
import '../theme/tokens.dart';
import 'common.dart';

/// The member-facing kit.
///
/// A dark panel carries the one figure a mwumini checks; amber carries the one
/// action; peach carries the softer tiles. Everything else stays on white.

/// Rounded dark panel. Used for the bahasha card, the calendar head, and any
/// place a number should read as the subject of the screen.
class HeroPanel extends StatelessWidget {
  const HeroPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Insets.lg + 2),
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
        borderRadius: BorderRadius.circular(Radii.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [s.panel, s.panelDeep],
        ),
      ),
      padding: padding,
      child: child,
    );
    if (onTap == null) return panel;
    return Pressable(onTap: onTap, child: panel);
  }
}

/// Circular progress with a figure in the middle, as on the "plan almost
/// done" card. [value] is 0..1.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.label,
    this.size = 66,
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
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) => CustomPaint(
          painter: _RingPainter(
            value: t,
            track: track ?? Colors.white.withValues(alpha: 0.18),
            fill: fill ?? s.amber,
            stroke: size * 0.11,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: labelColor ?? s.onPanel,
                fontSize: size * 0.24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
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
    final rect = Offset.zero & size;
    final centre = rect.center;
    final radius = (math.min(size.width, size.height) - stroke) / 2;

    final base = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(centre, radius, base);

    if (value <= 0) return;
    final arc = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      arc,
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

/// Three figures side by side, divided by hairlines — the profile header from
/// the first reference.
class StatStrip extends StatelessWidget {
  const StatStrip({super.key, required this.stats, this.onPanel = true});

  final List<Stat> stats;

  /// True when the strip sits on a dark panel.
  final bool onPanel;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final strong = onPanel ? s.onPanel : s.ink;
    final quiet = onPanel ? s.onPanel.withValues(alpha: 0.7) : s.muted;
    final rule = onPanel ? s.onPanel.withValues(alpha: 0.2) : s.hairline;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) Container(width: 1, height: 34, color: rule),
          Expanded(
            child: Column(
              children: [
                FittedBox(
                  child: Text(
                    stats[i].value,
                    style: TextStyle(
                      color: strong,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stats[i].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: quiet, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// The amber pill. One per screen, for the action that matters.
class AmberButton extends StatelessWidget {
  const AmberButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final enabled = onPressed != null;
    return Pressable(
      onTap: onPressed,
      scale: 0.96,
      child: Container(
        height: compact ? 40 : 50,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? Insets.lg : Insets.xl,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? s.amber : s.hairline,
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: compact ? 16 : 18,
                color: enabled ? s.onAmber : s.muted,
              ),
              const SizedBox(width: Insets.sm),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: enabled ? s.onAmber : s.muted,
                  fontSize: compact ? 13.5 : 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A soft tile from the schedule grid: title, a quiet second line, and an
/// optional icon. Peach and white variants alternate down the page.
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
      SoftTone.warm => (s.peach, s.onPeach, s.onPeach.withValues(alpha: 0.7)),
      SoftTone.dark => (s.panel, s.onPanel, s.onPanel.withValues(alpha: 0.75)),
    };

    return Pressable(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: tone == SoftTone.plain ? Border.all(color: s.hairline) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: Icon(icon, size: 19, color: fg),
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
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
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

enum SoftTone { plain, warm, dark }

/// A row on the day's timeline: the hour in the margin, the event beside it.
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

  /// Marks the next thing due, which gets the peach card and the amber rule.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Padding(
              padding: const EdgeInsets.only(top: Insets.md + 2),
              child: Text(
                time,
                style: TextStyle(
                  color: highlight ? s.amber : s.muted,
                  fontSize: 12,
                  fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
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
                tone: highlight ? SoftTone.warm : SoftTone.plain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Overlapping round avatars, as on the meeting cards. Initials only — the
/// app holds no member photographs.
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.initials,
    this.size = 26,
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
    final palette = [s.panel, s.amber, DkmzvBrand.sage, DkmzvBrand.clothGreen];

    return SizedBox(
      height: size,
      width: shown.isEmpty
          ? 0
          : size +
                (shown.length - 1) * size * 0.66 +
                (extra > 0 ? size * 0.66 : 0),
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * size * 0.66,
              child: _Bubble(
                text: shown[i],
                size: size,
                color: palette[i % palette.length],
              ),
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
        border: Border.all(color: s.card, width: 1.6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Big friendly page heading, with the last word carried in amber.
class DisplayHeading extends StatelessWidget {
  const DisplayHeading({super.key, required this.lead, required this.accent});

  final String lead;
  final String accent;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$lead '),
          TextSpan(
            text: accent,
            style: TextStyle(color: s.amber),
          ),
        ],
      ),
      style: TextStyle(
        fontFamily: DkmzvBrand.display,
        color: s.ink,
        fontSize: 27,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
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
