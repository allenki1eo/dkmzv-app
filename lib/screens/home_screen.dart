import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../widgets/common.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenIbada});
  final VoidCallback onOpenIbada;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final p = store.palette;
    final church = store.data.church;
    final ibada = store.featuredService;
    final announcements = store.data.sortedAnnouncements;

    return Scaffold(
      appBar: BrandAppBar(title: s.appName),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        children: [
          Text(
            church.name(store.sw),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: p.cloth,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            s.companion,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: p.cloth.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 6),
          const GoldRule(),
          const SizedBox(height: 16),
          const SeasonBanner(),
          const SizedBox(height: 14),
          const SundayTimesCard(),
          if (ibada != null) ...[
            SectionLabel(s.latestIbada),
            Card(
              child: InkWell(
                onTap: () {
                  store.openIbada(ibada.id);
                  onOpenIbada();
                },
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatDate(ibada.date, store.localeCode),
                          style: TextStyle(
                              color: p.cloth,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2)),
                      const SizedBox(height: 6),
                      Text(ibada.theme(store.sw),
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(ibada.sermonTitle(store.sw)),
                      const SizedBox(height: 12),
                      Text(s.openIbada,
                          style: TextStyle(
                              color: p.cloth, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
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
                              color: p.metal.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(s.pinned,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: p.cloth)),
                          ),
                        Text(formatDate(a.date, store.localeCode),
                            style: TextStyle(
                                color: p.cloth.withValues(alpha: 0.55),
                                fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(a.title(store.sw),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(a.body(store.sw), style: const TextStyle(height: 1.45)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(s.offlineNote,
              style: TextStyle(
                  color: p.cloth.withValues(alpha: 0.55), fontSize: 12)),
          const SizedBox(height: 6),
          Text(s.whatsappComplement,
              style: TextStyle(
                  color: p.cloth.withValues(alpha: 0.55), fontSize: 12)),
          const SizedBox(height: 6),
          Text(s.fcmStub,
              style: TextStyle(
                  color: p.cloth.withValues(alpha: 0.45), fontSize: 11)),
        ],
      ),
    );
  }
}
