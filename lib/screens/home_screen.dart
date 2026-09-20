import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenIbada});
  final VoidCallback onOpenIbada;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final church = store.data.church;
    final ibada = store.featuredService;
    final announcements = store.data.sortedAnnouncements;

    return Scaffold(
      appBar: BrandAppBar(title: s.appName),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(church.name(store.sw),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: DkmzvBrand.purple,
                    fontWeight: FontWeight.w700,
                  )),
          const SizedBox(height: 4),
          Text(s.companion,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: DkmzvBrand.muted)),
          const SizedBox(height: 12),
          Card(
            color: DkmzvBrand.purple,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.sundayTimes,
                      style: const TextStyle(
                          color: DkmzvBrand.gold,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4)),
                  const SizedBox(height: 10),
                  for (final slot in store.data.sundayTimes) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 56,
                          child: Text(slot.time,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16)),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(slot.title(store.sw),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                              Text(slot.note(store.sw),
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
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
            ),
          ),
          if (ibada != null) ...[
            SectionLabel(s.latestIbada),
            Card(
              child: InkWell(
                onTap: () {
                  store.openIbada(ibada.id);
                  onOpenIbada();
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatDate(ibada.date, store.localeCode),
                          style: const TextStyle(
                              color: DkmzvBrand.green,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(ibada.theme(store.sw),
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(ibada.sermonTitle(store.sw)),
                      const SizedBox(height: 8),
                      Text(s.openIbada,
                          style: const TextStyle(
                              color: DkmzvBrand.purple,
                              fontWeight: FontWeight.w700)),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (a.pinned)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: DkmzvBrand.gold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(s.pinned,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: DkmzvBrand.purple)),
                          ),
                        Text(formatDate(a.date, store.localeCode),
                            style: const TextStyle(
                                color: DkmzvBrand.muted, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(a.title(store.sw),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(a.body(store.sw)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(s.fcmStub,
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(s.offlineNote,
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(s.whatsappComplement,
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 12)),
        ],
      ),
    );
  }
}
