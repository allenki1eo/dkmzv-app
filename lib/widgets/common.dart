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

class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0x14000000)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(DkmzvBrand.logoAsset, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: DkmzvBrand.ink,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      actions: [
        const LocaleToggle(),
        ...?actions,
      ],
    );
  }
}

class LocaleToggle extends StatelessWidget {
  const LocaleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final sw = store.sw;
    final accent = DkmzvBrand.accent(store.palette);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: store.toggleLocale,
        style: TextButton.styleFrom(
          foregroundColor: accent,
          backgroundColor: accent.withValues(alpha: 0.08),
          minimumSize: const Size(44, 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(sw ? 'EN' : 'SW',
            style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.6)),
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
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 4, 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: DkmzvBrand.ink,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(text, textAlign: TextAlign.center,
          style: const TextStyle(color: DkmzvBrand.muted)),
    );
  }
}

class SeasonBanner extends StatelessWidget {
  const SeasonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final moment = store.moment;
    final p = moment.palette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChurchYearScreen()),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
            border: Border.all(color: const Color(0x14000000)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 44,
                  decoration: BoxDecoration(
                    color: p.cloth,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: p.metal, width: 1.2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.todayInYear,
                        style: const TextStyle(
                          color: DkmzvBrand.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        moment.name(s),
                        style: const TextStyle(
                          color: DkmzvBrand.ink,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '${moment.clothName(s)} · ${moment.clothWhy(s)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: DkmzvBrand.accent(p),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: DkmzvBrand.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SundayTimesCard extends StatelessWidget {
  const SundayTimesCard({super.key, this.onOpenIbada});
  final VoidCallback? onOpenIbada;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final p = store.palette;
    final ibada = store.featuredService;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.cloth, p.clothDeep],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.sundayTimes,
            style: TextStyle(
              color: p.onCloth.withValues(alpha: 0.78),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ibada?.theme(store.sw) ?? s.latestIbada,
            style: TextStyle(
              color: p.onCloth,
              fontWeight: FontWeight.w700,
              fontSize: 22,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          for (final slot in store.data.sundayTimes.take(2))
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '${slot.time}  ·  ${slot.title(store.sw)}',
                style: TextStyle(
                  color: p.onCloth.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (onOpenIbada != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onOpenIbada,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: DkmzvBrand.accent(p),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(s.openIbada,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
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
    final color = accent ?? DkmzvBrand.accent(store.palette);
    final dt = DateTime.tryParse(startIso);
    final day = dt == null ? '—' : DateFormat('d').format(dt);
    final mon = dt == null
        ? ''
        : DateFormat.MMM(store.localeCode == 'en' ? 'en' : 'sw').format(dt);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(day,
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            height: 1)),
                    const SizedBox(height: 2),
                    Text(mon.toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
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
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            height: 1.25)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: DkmzvBrand.muted, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: DkmzvBrand.muted),
            ],
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
    final accent = DkmzvBrand.accent(pOf(context));
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
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
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.title(store.sw),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(formatDateTime(e.start, store.localeCode)),
          Text(e.place(store.sw)),
          const SizedBox(height: 8),
          Text(e.detail(store.sw)),
          const SizedBox(height: 8),
          Text(s.cat(e.category),
              style: const TextStyle(color: DkmzvBrand.muted)),
        ],
      ),
    ),
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

Color liturgical(String name) => paletteForColorName(name).cloth;
