import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../l10n/strings.dart';
import '../screens/church_year_screen.dart';
import '../theme/brand.dart';
import '../theme/liturgical.dart';

S sOf(BuildContext context) {
  final code = context.watch<ChurchStore>().localeCode;
  return S(code);
}

SeasonPalette pOf(BuildContext context) => context.watch<ChurchStore>().palette;

/// Identity accent of the active usharika, lifted for dark mode.
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
    final accent = accentOf(context);
    return AppBar(
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: accent.withValues(alpha: 0.35)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(DkmzvBrand.logoAsset, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
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
                        color: s.muted, fontSize: 11.5, height: 1.25),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [...?actions, const SizedBox(width: 8)],
    );
  }
}

class LocaleToggle extends StatelessWidget {
  const LocaleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final accent = accentOf(context);
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: TextButton(
        onPressed: store.toggleLocale,
        style: TextButton.styleFrom(
          foregroundColor: accent,
          backgroundColor: accent.withValues(alpha: 0.1),
          minimumSize: const Size(44, 34),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(store.sw ? 'EN' : 'SW',
            style:
                const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.6)),
      ),
    );
  }
}

class GoldRule extends StatelessWidget {
  const GoldRule({super.key, this.width = 40});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: DkmzvBrand.gold.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.action, this.onAction});
  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 24, action == null ? 2 : 0, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: s.ink,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.text, {super.key, this.icon});
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, color: s.muted.withValues(alpha: 0.6), size: 30),
            const SizedBox(height: 10),
          ],
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: s.muted, height: 1.45)),
        ],
      ),
    );
  }
}

/// Small status pill — live, exempt, cathedral, approximate.
class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.color, this.filled = false, this.icon});
  final String label;
  final Color? color;
  final bool filled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tone = color ?? accentOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? tone : tone.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 12, color: filled ? Colors.white : tone),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
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
    return Material(
      color: s.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: s.hairline),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: tone, size: 20),
              const SizedBox(height: 10),
              Text(value,
                  style: TextStyle(
                    fontFamily: DkmzvBrand.display,
                    fontSize: 24,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: s.ink,
                  )),
              const SizedBox(height: 4),
              Text(label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: s.muted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class SeasonBanner extends StatelessWidget {
  const SeasonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final moment = store.moment;
    final p = moment.palette;
    return Material(
      color: surfaces.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChurchYearScreen()),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: surfaces.hairline),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 38,
                  decoration: BoxDecoration(
                    color: p.cloth,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: p.metal, width: 1.1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moment.name(s),
                        style: TextStyle(
                          color: surfaces.ink,
                          fontSize: 15,
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
          ),
        ),
      ),
    );
  }
}

/// The Sunday cloth card. Vestment colour stays locked to the church year.
class SundayTimesCard extends StatelessWidget {
  const SundayTimesCard({super.key, this.onOpenIbada});
  final VoidCallback? onOpenIbada;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final p = store.palette;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.cloth, p.clothDeep],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.sundayTimes.toUpperCase(),
            style: TextStyle(
              color: p.onCloth.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          for (final slot in store.data.sundayTimes.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 58,
                    child: Text(
                      slot.time,
                      style: TextStyle(
                        color: p.onCloth,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      slot.title(store.sw),
                      style: TextStyle(
                        color: p.onCloth.withValues(alpha: 0.9),
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (onOpenIbada != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onOpenIbada,
                style: FilledButton.styleFrom(
                  backgroundColor: p.onCloth,
                  foregroundColor: p.cloth,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
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
    final color = accent ?? accentOf(context);
    final dt = DateTime.tryParse(startIso);
    final day = dt == null ? '—' : DateFormat('d').format(dt);
    final mon = dt == null
        ? ''
        : DateFormat.MMM(store.localeCode == 'en' ? 'en' : 'sw').format(dt);
    return Material(
      color: surfaces.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: surfaces.hairline),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 10, 11),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(day,
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w700,
                              fontSize: 19,
                              height: 1)),
                      const SizedBox(height: 2),
                      Text(mon.toUpperCase(),
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              letterSpacing: 0.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: surfaces.ink,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              height: 1.25)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: surfaces.muted, fontSize: 12.5)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: surfaces.muted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent, size: 21),
              ),
              const SizedBox(height: 7),
              Text(label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: surfaces.ink,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500)),
            ],
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? Icons.info_outline, size: 14, color: s.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style:
                    TextStyle(color: s.muted, fontSize: 12.5, height: 1.4)),
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
    showDragHandle: true,
    builder: (sheetContext) {
      final surfaces = Surfaces.of(sheetContext);
      return Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.title(store.sw),
                style: Theme.of(sheetContext).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(formatDateTime(e.start, store.localeCode)),
            Text(e.place(store.sw),
                style: TextStyle(color: surfaces.muted)),
            const SizedBox(height: 12),
            Text(e.detail(store.sw)),
            const SizedBox(height: 14),
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
