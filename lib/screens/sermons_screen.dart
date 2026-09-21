import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../data/youtube.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import 'sermon_player_screen.dart';

class SermonsScreen extends StatelessWidget {
  const SermonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final items = [...store.data.sermons]..sort((a, b) {
        if (a.isLive != b.isLive) return a.isLive ? -1 : 1;
        return b.date.compareTo(a.date);
      });

    return Scaffold(
      appBar: AppBar(title: Text(s.sermons)),
      body: items.isEmpty
          ? Center(child: Text(s.noSermons))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: items.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(s.liveLead,
                        style: const TextStyle(
                            color: DkmzvBrand.muted, height: 1.4)),
                  );
                }
                final ser = items[i - 1];
                final cong = store.data.congregationById(ser.congregationId);
                final playable = youtubeVideoId(ser.mediaUrl) != null;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (ser.isLive) ...[
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: DkmzvBrand.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(s.liveNow,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ],
                            Text(formatDate(ser.date, store.localeCode),
                                style: const TextStyle(
                                    color: DkmzvBrand.muted, fontSize: 12)),
                          ],
                        ),
                        Text(ser.title(store.sw),
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('${s.preacher}: ${ser.preacher(store.sw)}'),
                        if (cong != null)
                          Text(cong.name(store.sw),
                              style: const TextStyle(
                                  color: DkmzvBrand.muted, fontSize: 13)),
                        if (ser.note(store.sw).isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(ser.note(store.sw),
                              style: const TextStyle(
                                  color: DkmzvBrand.muted, fontSize: 13)),
                        ],
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: ser.mediaUrl.isEmpty
                                  ? null
                                  : () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              SermonPlayerScreen(sermon: ser),
                                        ),
                                      ),
                              icon: Icon(playable
                                  ? Icons.play_circle_outline
                                  : Icons.ondemand_video_outlined),
                              label: Text(
                                  playable ? s.watchInApp : s.openMedia),
                            ),
                            if (ser.mediaUrl.isNotEmpty)
                              OutlinedButton.icon(
                                onPressed: () => shareText(
                                  '${ser.title(store.sw)}\n${ser.mediaUrl}',
                                  subject: ser.title(store.sw),
                                ),
                                icon: const Icon(Icons.share_outlined),
                                label: Text(s.shareLink),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
