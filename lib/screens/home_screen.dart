import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import '../widgets/parish.dart';
import 'announcements_screen.dart';
import 'congregations_screen.dart';
import 'giving_screen.dart';
import 'jumuiya_map_screen.dart';
import 'sermons_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenIbada,
    required this.onOpenHymns,
    required this.onOpenEvents,
  });

  final VoidCallback onOpenIbada;
  final VoidCallback onOpenHymns;
  final VoidCallback onOpenEvents;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final accent = accentOf(context);
    final congregation = store.selectedCongregation;
    final churchName =
        congregation?.name(store.sw) ?? store.data.church.name(store.sw);
    final ibada = store.featuredService;
    final announcements = store.data.sortedAnnouncements;
    final events = [...store.data.events]
      ..sort((a, b) => a.start.compareTo(b.start));
    final upcoming = events.take(2).toList();

    return Scaffold(
      appBar: BrandAppBar(
        title: churchName,
        subtitle: congregation?.tagline(store.sw) ?? s.churchShort,
        actions: const [ParishButton(), LocaleToggle()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          Text(
            ibada?.theme(store.sw) ?? s.companion,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          if (ibada != null) ...[
            const SizedBox(height: 10),
            Text(
              '${formatDate(ibada.date, store.localeCode)} · ${ibada.sermonTitle(store.sw)}',
              style: TextStyle(color: surfaces.muted, fontSize: 14.5, height: 1.4),
            ),
          ],
          const SizedBox(height: 18),
          const SeasonBanner(),
          const SizedBox(height: 12),
          const LiveSermonBanner(),
          const SizedBox(height: 6),
          Row(
            children: [
              ShortcutChip(
                  icon: Icons.menu_book_outlined,
                  label: s.tabIbada,
                  onTap: onOpenIbada),
              ShortcutChip(
                  icon: Icons.play_circle_outline,
                  label: s.sermons,
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SermonsScreen()),
                      )),
              ShortcutChip(
                  icon: Icons.volunteer_activism_outlined,
                  label: s.giving,
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GivingScreen()),
                      )),
              ShortcutChip(
                  icon: Icons.map_outlined,
                  label: s.jumuiyaMap,
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const JumuiyaMapScreen()),
                      )),
            ],
          ),
          const SizedBox(height: 18),
          SundayTimesCard(onOpenIbada: () {
            if (ibada != null) store.openIbada(ibada.id);
            onOpenIbada();
          }),
          if (upcoming.isNotEmpty) ...[
            SectionLabel(s.upcoming.toUpperCase(),
                action: s.seeAllEvents, onAction: onOpenEvents),
            for (var i = 0; i < upcoming.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DateRailTile(
                  startIso: upcoming[i].start,
                  title: upcoming[i].title(store.sw),
                  subtitle:
                      '${formatDateTime(upcoming[i].start, store.localeCode)} · ${upcoming[i].place(store.sw)}',
                  accent: i.isOdd ? DkmzvBrand.gold : accent,
                  onTap: () => showEventSheet(context, upcoming[i]),
                ),
              ),
          ],
          SectionLabel(
            s.announcements.toUpperCase(),
            action: announcements.length > 2 ? s.seeAll : null,
            onAction: announcements.length > 2
                ? () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const AnnouncementsScreen()),
                    )
                : null,
          ),
          if (announcements.isEmpty)
            EmptyState(s.announcements, icon: Icons.campaign_outlined),
          for (final a in announcements.take(2))
            AnnouncementCard(announcement: a),
          const SizedBox(height: 10),
          FootNote(s.offlineNote, icon: Icons.offline_pin_outlined),
        ],
      ),
    );
  }
}
