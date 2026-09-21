import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../data/youtube.dart';
import '../theme/brand.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/tab_bar.dart';
import '../widgets/video.dart';
import 'channel_live_screen.dart';

class SermonsScreen extends StatelessWidget {
  const SermonsScreen({super.key, this.embedded = false});

  /// True when the screen is a tab in the shell rather than a pushed route.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final items = [...store.data.sermons]
      ..sort((a, b) {
        if (a.isLive != b.isLive) return a.isLive ? -1 : 1;
        return b.date.compareTo(a.date);
      });
    final featured = items.isEmpty ? null : items.first;
    final rest = items.skip(1).toList();
    final channelLive = youtubeChannelLiveEmbedUrl(store.youtubeChannel);

    return Scaffold(
      appBar: embedded
          ? AppBar(
              titleSpacing: Insets.gutter,
              title: Text(
                s.sermons,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : AppBar(title: Text(s.sermons)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Insets.gutter,
          Insets.xs,
          Insets.gutter,
          GlassTabBar.scrollInset,
        ),
        children: [
          if (featured == null)
            EmptyState(s.noSermonYet, icon: Icons.ondemand_video_outlined)
          else
            WatchCard(sermon: featured),
          if (channelLive != null) ...[
            const SizedBox(height: Insets.md),
            TileRow(
              icon: Icons.sensors,
              title: s.channelLiveTitle,
              subtitle: s.channelLiveNote,
              iconColor: DkmzvBrand.live,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChannelLiveScreen()),
              ),
            ),
          ],
          if (rest.isNotEmpty) ...[
            SectionLabel(s.allSermons),
            for (final ser in rest)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.md),
                child: SermonRow(sermon: ser),
              ),
          ],
          const SizedBox(height: Insets.sm),
          Text(
            s.liveLead,
            style: TextStyle(
              color: surfaces.muted,
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
