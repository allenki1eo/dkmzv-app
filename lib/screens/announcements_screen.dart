import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final items = store.data.sortedAnnouncements;
    return Scaffold(
      appBar: AppBar(title: Text(s.announcements)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          if (items.isEmpty)
            EmptyState(s.announcements, icon: Icons.campaign_outlined),
          for (final a in items) AnnouncementCard(announcement: a),
          const SizedBox(height: 12),
          FootNote(s.fcmStub, icon: Icons.notifications_none),
          FootNote(s.whatsappComplement, icon: Icons.chat_bubble_outline),
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.announcement});
  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (announcement.pinned) ...[
                  Pill(s.pinned, icon: Icons.push_pin_outlined),
                  const SizedBox(width: 8),
                ],
                Text(formatDate(announcement.date, store.localeCode),
                    style: TextStyle(color: surfaces.muted, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),
            Text(announcement.title(store.sw),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(announcement.body(store.sw),
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
