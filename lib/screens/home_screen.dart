import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../theme/brand.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/parish.dart';
import '../widgets/video.dart';
import 'announcements_screen.dart';
import 'events_screen.dart';
import 'giving_screen.dart';
import 'jumuiya_map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onOpenIbada,
    required this.onOpenSermons,
  });

  final VoidCallback onOpenIbada;
  final VoidCallback onOpenSermons;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final congregation = store.selectedCongregation;
    final churchName =
        congregation?.name(store.sw) ?? store.data.church.name(store.sw);
    final ibada = store.featuredService;
    final watch = store.watchNow;
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
        padding: const EdgeInsets.fromLTRB(
            Insets.gutter, Insets.xs, Insets.gutter, Insets.xxl + Insets.sm),
        children: [
          if (ibada != null)
            Text(
              formatDate(ibada.date, store.localeCode),
              style: TextStyle(
                color: surfaces.muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          const SizedBox(height: Insets.sm),
          Text(
            ibada?.theme(store.sw) ?? s.companion,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: Insets.lg + 2),
          const SeasonBanner(),
          const SizedBox(height: Insets.md),
          if (watch != null) WatchCard(sermon: watch),
          const SizedBox(height: Insets.md),
          Row(
            children: [
              ShortcutChip(
                  icon: Icons.menu_book_outlined,
                  label: s.tabIbada,
                  onTap: onOpenIbada),
              ShortcutChip(
                  icon: Icons.play_circle_outline,
                  label: s.sermons,
                  onTap: onOpenSermons),
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
          const SizedBox(height: Insets.lg),
          SundayTimesCard(onOpenIbada: () {
            if (ibada != null) store.openIbada(ibada.id);
            onOpenIbada();
          }),
          if (upcoming.isNotEmpty) ...[
            SectionLabel(s.upcoming,
                action: s.seeAllEvents,
                onAction: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EventsScreen()),
                    )),
            for (final e in upcoming)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm + 2),
                child: DateRailTile(
                  startIso: e.start,
                  title: e.title(store.sw),
                  subtitle:
                      '${formatDateTime(e.start, store.localeCode)} · ${e.place(store.sw)}',
                  onTap: () => showEventSheet(context, e),
                ),
              ),
          ],
          SectionLabel(
            s.announcements,
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
          const SizedBox(height: Insets.md),
          FootNote(s.offlineNote, icon: Icons.offline_pin_outlined),
        ],
      ),
    );
  }
}
