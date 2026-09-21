import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../l10n/strings.dart';
import '../screens/church_year_screen.dart';
import '../theme/brand.dart';
import '../theme/liturgical.dart';
import '../theme/tokens.dart';

S sOf(BuildContext context) {
  final code = context.watch<ChurchStore>().localeCode;
  return S(code);
}

SeasonPalette pOf(BuildContext context) => context.watch<ChurchStore>().palette;

/// Identity accent of the active usharika, lifted for dark mode. Used for
/// icons, active states and small badges — never to fill a card or a button.
Color accentOf(BuildContext context) => accentForBrightness(
  context.watch<ChurchStore>().parishAccent,
  Theme.of(context).brightness,
);

class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return AppBar(
      titleSpacing: Insets.gutter,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.sm),
              color: Colors.white,
              border: Border.all(color: s.hairline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(DkmzvBrand.logoAsset, fit: BoxFit.cover),
          ),
          const SizedBox(width: Insets.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: s.ink,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    fontSize: 17,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: s.muted,
                      fontSize: 11.5,
                      height: 1.25,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        ...?actions,
        const SizedBox(width: Insets.md),
      ],
    );
  }
}

/// Quiet square icon button used in app bars — neutral, never accent-filled.
class BarButton extends StatelessWidget {
  const BarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: Insets.sm),
      child: Tooltip(
        message: tooltip ?? '',
        child: Material(
          color: s.card,
          borderRadius: BorderRadius.circular(Radii.sm),
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.sm),
            onTap: onPressed,
            child: Ink(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Radii.sm),
                border: Border.all(color: s.hairline),
              ),
              child: Icon(icon, size: 19, color: color ?? s.ink),
            ),
          ),
        ),
      ),
    );
  }
}

class LocaleToggle extends StatelessWidget {
  const LocaleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = Surfaces.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: Insets.sm),
      child: Material(
        color: s.card,
        borderRadius: BorderRadius.circular(Radii.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.sm),
          onTap: store.toggleLocale,
          child: Ink(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: Insets.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.sm),
              border: Border.all(color: s.hairline),
            ),
            child: Center(
              child: Text(
                store.sw ? 'EN' : 'SW',
                style: TextStyle(
                  color: s.ink,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Section heading. Sentence case, generous space above, optional trailing
/// action — the pattern every calm list app uses.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.action, this.onAction});
  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        Insets.xl + 4,
        action == null ? 0 : 0,
        Insets.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: s.ink,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: s.muted,
                padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(action!),
            ),
        ],
      ),
    );
  }
}

/// Plain white card with a hairline. No shadow anywhere in the app.
/// Press feedback for anything tappable that is not a button.
///
/// The surface dips a little under the finger and the phone gives a light
/// tick. It is a small thing, but it is most of what separates a tap that
/// feels considered from one that feels like a web page.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.scale = 0.975,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v && mounted) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null || widget.onLongPress != null;
    if (!enabled) return widget.child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapCancel: () => _set(false),
      onTapUp: (_) => _set(false),
      onTap: widget.onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              widget.onTap!();
            },
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              HapticFeedback.mediumImpact();
              widget.onLongPress!();
            },
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _down ? 0.9 : 1,
          duration: const Duration(milliseconds: 140),
          child: widget.child,
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Insets.lg),
    this.borderColor,
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? borderColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final shape = BorderRadius.circular(Radii.lg);
    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? s.card,
        borderRadius: shape,
        border: Border.all(color: borderColor ?? s.hairline),
      ),
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return surface;
    return Pressable(onTap: onTap, child: surface);
  }
}

/// List row: rounded-square icon, title, subtitle, chevron.
class TileRow extends StatelessWidget {
  const TileRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final tone = iconColor ?? accentOf(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(
        Insets.md,
        Insets.md,
        Insets.md,
        Insets.md,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Icon(icon, color: tone, size: 19),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: s.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: s.muted,
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          trailing ?? Icon(Icons.chevron_right, color: s.muted, size: 20),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.text, {super.key, this.icon, this.action});
  final String text;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.xxl,
        horizontal: Insets.xl,
      ),
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, color: s.muted.withValues(alpha: 0.6), size: 30),
            const SizedBox(height: Insets.md),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: s.muted, height: 1.45),
          ),
          if (action != null) ...[const SizedBox(height: Insets.lg), action!],
        ],
      ),
    );
  }
}

/// Small status pill — live, exempt, cathedral, approximate.
class Pill extends StatelessWidget {
  const Pill(
    this.label, {
    super.key,
    this.color,
    this.filled = false,
    this.icon,
  });
  final String label;
  final Color? color;
  final bool filled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final surfaces = Surfaces.of(context);
    final tone = color ?? accentOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.sm + 2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: filled ? tone : tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: filled ? surfaces.card : tone),
            const SizedBox(width: Insets.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: filled ? Colors.white : tone,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact number card used on the admin dashboard.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.color,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final tone = color ?? accentOf(context);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Insets.lg - 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tone, size: 19),
          const SizedBox(height: Insets.md),
          Text(
            value,
            style: TextStyle(
              fontFamily: DkmzvBrand.display,
              fontSize: 26,
              height: 1,
              fontWeight: FontWeight.w700,
              color: s.ink,
            ),
          ),
          const SizedBox(height: Insets.xs),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: s.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// The season strip. The vestment colour shows as a ribbon only — the church
/// year is stated, not painted over the interface.
class SeasonBanner extends StatelessWidget {
  const SeasonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final moment = store.moment;
    final p = moment.palette;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        Insets.md,
        Insets.md,
        Insets.md,
        Insets.md,
      ),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const ChurchYearScreen())),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 34,
            decoration: BoxDecoration(
              color: p.cloth,
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moment.name(s),
                  style: TextStyle(
                    color: surfaces.ink,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                Text(
                  moment.clothName(s),
                  style: TextStyle(color: surfaces.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: surfaces.muted, size: 20),
        ],
      ),
    );
  }
}

/// Sunday times. A plain card with the vestment as a ribbon down the side.
class SundayTimesCard extends StatelessWidget {
  const SundayTimesCard({super.key, this.onOpenIbada});
  final VoidCallback? onOpenIbada;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final p = store.palette;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        Insets.lg,
        Insets.lg,
        Insets.lg,
        Insets.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: p.cloth,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: Insets.sm),
              Text(
                s.sundayTimes,
                style: TextStyle(
                  color: surfaces.ink,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.md),
          for (final slot in store.data.sundayTimes.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 54,
                    child: Text(
                      slot.time,
                      style: TextStyle(
                        color: surfaces.ink,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      slot.title(store.sw),
                      style: TextStyle(color: surfaces.muted, fontSize: 14.5),
                    ),
                  ),
                ],
              ),
            ),
          if (onOpenIbada != null) ...[
            const SizedBox(height: Insets.xs),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onOpenIbada,
                child: Text(s.openIbada),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DateRailTile extends StatelessWidget {
  const DateRailTile({
    super.key,
    required this.startIso,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.accent,
  });

  final String startIso;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final surfaces = Surfaces.of(context);
    final dt = DateTime.tryParse(startIso);
    final day = dt == null ? '—' : DateFormat('d').format(dt);
    final mon = dt == null
        ? ''
        : DateFormat.MMM(store.localeCode == 'en' ? 'en' : 'sw').format(dt);
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(
        Insets.md,
        Insets.md,
        Insets.md,
        Insets.md,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 48,
            decoration: BoxDecoration(
              color: surfaces.sunken,
              borderRadius: BorderRadius.circular(Radii.sm),
              border: Border.all(color: surfaces.hairline),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    color: surfaces.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mon.toUpperCase(),
                  style: TextStyle(
                    color: surfaces.muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 9.5,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: surfaces.ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: surfaces.muted, fontSize: 12.5),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: surfaces.muted, size: 20),
        ],
      ),
    );
  }
}

/// Square quick action used in the home grid.
class ShortcutChip extends StatelessWidget {
  const ShortcutChip({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = accentOf(context);
    final surfaces = Surfaces.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xs),
        child: Material(
          color: surfaces.card,
          borderRadius: BorderRadius.circular(Radii.md),
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.md),
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Radii.md),
                border: Border.all(color: surfaces.hairline),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: Insets.md,
                horizontal: Insets.sm,
              ),
              child: Column(
                children: [
                  Icon(icon, color: accent, size: 21),
                  const SizedBox(height: Insets.sm),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: surfaces.ink,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quiet footnote line used instead of stacked grey paragraphs.
class FootNote extends StatelessWidget {
  const FootNote(this.text, {super.key, this.icon});
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? Icons.info_outline, size: 14, color: s.muted),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: s.muted, fontSize: 12.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

void showEventSheet(BuildContext context, ChurchEvent e) {
  final store = context.read<ChurchStore>();
  final s = S(store.localeCode);
  showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      final surfaces = Surfaces.of(sheetContext);
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          Insets.gutter,
          0,
          Insets.gutter,
          Insets.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.title(store.sw),
              style: Theme.of(sheetContext).textTheme.headlineSmall,
            ),
            const SizedBox(height: Insets.md),
            Text(formatDateTime(e.start, store.localeCode)),
            Text(e.place(store.sw), style: TextStyle(color: surfaces.muted)),
            const SizedBox(height: Insets.md),
            Text(e.detail(store.sw)),
            const SizedBox(height: Insets.lg),
            Pill(s.cat(e.category)),
          ],
        ),
      );
    },
  );
}

String formatDate(String iso, String locale) {
  final dt = DateTime.tryParse(iso);
  if (dt == null) return iso;
  final loc = locale == 'en' ? 'en' : 'sw';
  return DateFormat.yMMMEd(loc).format(dt);
}

String formatDateTime(String iso, String locale) {
  final dt = DateTime.tryParse(iso);
  if (dt == null) return iso;
  final loc = locale == 'en' ? 'en' : 'sw';
  return DateFormat.yMMMd(loc).add_Hm().format(dt);
}

String formatMoney(int amount) =>
    NumberFormat.decimalPattern('en').format(amount);

Color liturgical(String name) => paletteForColorName(name).cloth;
