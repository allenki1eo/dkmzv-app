import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import 'contact_screen.dart';
import 'congregations_screen.dart';
import 'giving_screen.dart';

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
    final p = store.palette;
    final accent = DkmzvBrand.accent(p);
    final congregation = store.selectedCongregation;
    final churchName =
        congregation?.name(store.sw) ?? store.data.church.name(store.sw);
    final ibada = store.featuredService;
    final announcements = store.data.sortedAnnouncements;
    final events = [...store.data.events]
      ..sort((a, b) => a.start.compareTo(b.start));
    final upcoming = events.take(4).toList();
    final pastor = store.data.contacts.isEmpty ? null : store.data.contacts.first;
    final rails = [
      accent,
      DkmzvBrand.gold,
      DkmzvBrand.sage,
      DkmzvBrand.red,
    ];

    return Scaffold(
      appBar: BrandAppBar(title: s.appName),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Text(
            churchName,
            style: const TextStyle(
              color: DkmzvBrand.muted,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ibada?.theme(store.sw) ?? s.companion,
            style: const TextStyle(
              color: DkmzvBrand.ink,
              fontWeight: FontWeight.w800,
              fontSize: 32,
              height: 1.12,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ibada == null
                ? s.companion
                : '${formatDate(ibada.date, store.localeCode)} · ${ibada.sermonTitle(store.sw)}',
            style: const TextStyle(
              color: DkmzvBrand.muted,
              height: 1.4,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          const SeasonBanner(),
          const SizedBox(height: 18),
          Row(
            children: [
              ShortcutChip(
                  icon: Icons.menu_book_outlined,
                  label: s.tabIbada,
                  onTap: onOpenIbada),
              ShortcutChip(
                  icon: Icons.music_note_outlined,
                  label: s.tabHymns,
                  onTap: onOpenHymns),
              ShortcutChip(
                  icon: Icons.volunteer_activism_outlined,
                  label: s.giving,
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GivingScreen()),
                      )),
              ShortcutChip(
                  icon: Icons.place_outlined,
                  label: s.contact,
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ContactScreen()),
                      )),
            ],
          ),
          const SizedBox(height: 10),
          const LiveSermonBanner(),
          if (store.data.congregations.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final c in store.data.congregations)
                  ChoiceChip(
                    label: Text(c.name(store.sw)),
                    selected: congregation?.id == c.id,
                    onSelected: (_) => store.selectCongregation(c.id),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          SundayTimesCard(onOpenIbada: () {
            if (ibada != null) store.openIbada(ibada.id);
            onOpenIbada();
          }),
          if (pastor != null) ...[
            const SizedBox(height: 16),
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ContactScreen()),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: accent.withValues(alpha: 0.1),
                        backgroundImage: const AssetImage(DkmzvBrand.logoAsset),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pastor.role(store.sw),
                                style: TextStyle(
                                    color: accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(pastor.name(store.sw),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16)),
                            Text(s.roleCardLead,
                                style: const TextStyle(
                                    color: DkmzvBrand.muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: DkmzvBrand.muted),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (upcoming.isNotEmpty) ...[
            Row(
              children: [
                Expanded(child: SectionLabel(s.upcoming)),
                TextButton(
                  onPressed: onOpenEvents,
                  child: Text(s.seeAllEvents),
                ),
              ],
            ),
            for (var i = 0; i < upcoming.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DateRailTile(
                  startIso: upcoming[i].start,
                  title: upcoming[i].title(store.sw),
                  subtitle:
                      '${formatDateTime(upcoming[i].start, store.localeCode)} · ${upcoming[i].place(store.sw)}',
                  accent: rails[i % rails.length],
                  onTap: () => showEventSheet(context, upcoming[i]),
                ),
              ),
          ],
          SectionLabel(s.announcements),
          if (announcements.isEmpty) EmptyState(s.announcements),
          for (final a in announcements)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (a.pinned)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(s.pinned,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: accent)),
                          ),
                        Text(formatDate(a.date, store.localeCode),
                            style: const TextStyle(
                                color: DkmzvBrand.muted, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(a.title(store.sw),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            )),
                    const SizedBox(height: 6),
                    Text(a.body(store.sw),
                        style: const TextStyle(
                            height: 1.45, color: DkmzvBrand.ink)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(s.offlineNote,
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(s.whatsappComplement,
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(s.fcmStub,
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 11)),
        ],
      ),
    );
  }
}
