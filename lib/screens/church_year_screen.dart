import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../theme/brand.dart';
import '../theme/liturgical.dart';
import '../widgets/common.dart';

class ChurchYearScreen extends StatelessWidget {
  const ChurchYearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final p = store.palette;
    final calendar = LiturgicalCalendar.at(DateTime.now());

    final rows = <(Vestment, String, String)>[
      (Vestment.purple, s.colorPurple, s.whyPurple),
      (Vestment.green, s.colorGreen, s.whyGreen),
      (Vestment.white, s.colorWhiteGold, s.whyWhite),
      (Vestment.red, s.colorRed, s.whyRed),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(s.churchYear)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(s.lockedToSeason,
              style: TextStyle(
                color: p.cloth,
                fontWeight: FontWeight.w600,
                height: 1.4,
              )),
          const SizedBox(height: 12),
          Text(
            '${calendar.name(s)} · ${calendar.clothName(s)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(calendar.meaning(s)),
          SectionLabel(s.previewCloth),
          for (final row in rows)
            _ClothTile(
              vestment: row.$1,
              title: row.$2,
              body: row.$3,
              selected: store.palette.vestment == row.$1 &&
                  store.vestmentPreview != null,
              onTap: () => store.setVestmentPreview(row.$1.name),
            ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => store.setVestmentPreview(null),
            child: Text(s.followCalendar),
          ),
          SectionLabel(s.churchYear),
          _fact(s.seasonAdvent, s.meaningAdvent, SeasonPalette.purple.cloth),
          _fact(s.seasonLent, s.meaningLent, SeasonPalette.purple.cloth),
          _fact(s.seasonChristmas, s.meaningChristmas, SeasonPalette.white.clothDeep),
          _fact(s.seasonEaster, s.meaningEaster, SeasonPalette.white.clothDeep),
          _fact(s.seasonEpiphany, s.meaningEpiphany, SeasonPalette.green.cloth),
          _fact(s.seasonOrdinary, s.meaningOrdinary, SeasonPalette.green.cloth),
          _fact(s.seasonPalm, s.meaningPalm, SeasonPalette.red.cloth),
          _fact(s.seasonPentecost, s.meaningPentecost, SeasonPalette.red.cloth),
          _fact(s.seasonGoodFriday, s.meaningGoodFriday, SeasonPalette.red.cloth),
          _fact(s.seasonReformation, s.meaningReformation, SeasonPalette.red.cloth),
          _fact(s.seasonTrinity, s.meaningTrinity, SeasonPalette.white.clothDeep),
          _fact(s.seasonAllSaints, s.meaningAllSaints, SeasonPalette.white.clothDeep),
        ],
      ),
    );
  }

  Widget _fact(String title, String body, Color cloth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 48,
            decoration: BoxDecoration(
              color: cloth,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: DkmzvBrand.gold.withValues(alpha: 0.5)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(body, style: const TextStyle(height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClothTile extends StatelessWidget {
  const _ClothTile({
    required this.vestment,
    required this.title,
    required this.body,
    required this.selected,
    required this.onTap,
  });

  final Vestment vestment;
  final String title;
  final String body;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pal = SeasonPalette.of(vestment);
    return Card(
      child: ListTile(
        selected: selected,
        onTap: onTap,
        leading: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: pal.cloth,
            shape: BoxShape.circle,
            border: Border.all(color: pal.metal, width: 1.5),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(body),
      ),
    );
  }
}
