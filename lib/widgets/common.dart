import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    final p = pOf(context);
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: p.metal, width: 1.2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(DkmzvBrand.logoAsset, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: p.onCloth,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: p.metal.withValues(alpha: 0.85)),
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
    final p = store.palette;
    final sw = store.sw;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: store.toggleLocale,
        style: TextButton.styleFrom(foregroundColor: p.onCloth),
        child: Text(sw ? 'EN' : 'SW',
            style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.8)),
      ),
    );
  }
}

class GoldRule extends StatelessWidget {
  const GoldRule({super.key, this.width = 56});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1.5,
      color: DkmzvBrand.gold.withValues(alpha: 0.7),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final p = pOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
      child: Row(
        children: [
          Icon(Icons.add, size: 12, color: p.metal),
          const SizedBox(width: 8),
          Text(
            text.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: p.cloth,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: DkmzvBrand.gold.withValues(alpha: 0.35),
            ),
          ),
        ],
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
      child: Text(text, textAlign: TextAlign.center),
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
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChurchYearScreen()),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [p.cloth, p.clothDeep],
            ),
            border: Border.all(color: p.metal.withValues(alpha: 0.55)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: p.lightBar ? Colors.white : p.cloth,
                        shape: BoxShape.circle,
                        border: Border.all(color: p.metal, width: 2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.todayInYear.toUpperCase(),
                        style: TextStyle(
                          color: p.onCloth.withValues(alpha: 0.8),
                          fontSize: 11,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: p.metal, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  moment.name(s),
                  style: TextStyle(
                    color: p.onCloth,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${moment.clothName(s)} · ${moment.clothWhy(s)}',
                  style: TextStyle(
                    color: p.metal,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  moment.meaning(s),
                  style: TextStyle(
                    color: p.onCloth.withValues(alpha: 0.92),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SundayTimesCard extends StatelessWidget {
  const SundayTimesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final p = store.palette;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [p.cloth, p.clothDeep],
        ),
        border: Border.all(color: p.metal.withValues(alpha: 0.45)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.church, color: p.metal, size: 18),
              const SizedBox(width: 8),
              Text(
                s.sundayTimes.toUpperCase(),
                style: TextStyle(
                  color: p.metal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GoldRule(width: 40),
          const SizedBox(height: 12),
          for (final slot in store.data.sundayTimes) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 58,
                  child: Text(slot.time,
                      style: TextStyle(
                          color: p.onCloth,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(slot.title(store.sw),
                          style: TextStyle(
                              color: p.onCloth, fontWeight: FontWeight.w600)),
                      Text(slot.note(store.sw),
                          style: TextStyle(
                              color: p.onCloth.withValues(alpha: 0.78),
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
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
