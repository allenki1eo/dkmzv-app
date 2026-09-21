import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../data/youtube.dart';
import '../l10n/strings.dart';
import '../screens/sermon_player_screen.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../theme/tokens.dart';
import 'common.dart';

/// 16:9 YouTube poster with a play badge. Falls back to a quiet placeholder
/// when the phone is offline, which on Shinyanga data is often.
class YoutubeThumb extends StatelessWidget {
  const YoutubeThumb({
    super.key,
    required this.videoId,
    this.live = false,
    this.radius = Radii.md,
    this.height,
  });

  final String? videoId;
  final bool live;
  final double radius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final sl = sOf(context);
    final placeholder = Container(
      color: s.sunken,
      child: Center(
        child: Icon(Icons.ondemand_video_outlined,
            color: s.muted.withValues(alpha: 0.7), size: 26),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (videoId == null)
              placeholder
            else
              Image.network(
                youtubeThumbUrl(videoId!),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : placeholder,
              ),
            if (videoId != null)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x66000000)],
                  ),
                ),
              ),
            Center(
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 26),
              ),
            ),
            if (live)
              Positioned(
                left: Insets.sm,
                top: Insets.sm,
                child: LiveBadge(label: sl.liveNow),
              ),
          ],
        ),
      ),
    );
  }
}

class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
      decoration: BoxDecoration(
        color: DkmzvBrand.live,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: Colors.white, size: 7),
          const SizedBox(width: Insets.xs + 1),
          Text(label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              )),
        ],
      ),
    );
  }
}

/// The one card that answers "where do I watch?" — live stream if the office
/// flipped the switch, otherwise the most recent sermon.
class WatchCard extends StatelessWidget {
  const WatchCard({super.key, required this.sermon});
  final Sermon sermon;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final id = youtubeVideoId(sermon.mediaUrl);

    void open() => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SermonPlayerScreen(sermon: sermon)),
        );

    return AppCard(
      onTap: open,
      padding: const EdgeInsets.all(Insets.md),
      borderColor: sermon.isLive
          ? DkmzvBrand.live.withValues(alpha: 0.45)
          : surfaces.hairline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubeThumb(videoId: id, live: sermon.isLive),
          const SizedBox(height: Insets.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!sermon.isLive)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Insets.xs),
                    child: Text(
                      s.latestSermon,
                      style: TextStyle(
                        color: surfaces.muted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                Text(
                  sermon.title(store.sw),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: surfaces.ink,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                      height: 1.25),
                ),
                const SizedBox(height: 2),
                Text(
                  sermon.preacher(store.sw),
                  style: TextStyle(color: surfaces.muted, fontSize: 13),
                ),
                const SizedBox(height: Insets.md),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: open,
                        icon: Icon(
                            sermon.isLive
                                ? Icons.sensors
                                : Icons.play_arrow_rounded,
                            size: 20),
                        label: Text(sermon.isLive ? s.watchLive : s.watchInApp),
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    _ShareButton(sermon: sermon),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.sermon});
  final Sermon sermon;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    return Tooltip(
      message: s.shareLink,
      child: Material(
        color: surfaces.card,
        borderRadius: BorderRadius.circular(Radii.pill),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.pill),
          onTap: sermon.mediaUrl.isEmpty
              ? null
              : () => shareText(
                    '${sermon.title(store.sw)}\n${sermon.mediaUrl}',
                    subject: sermon.title(store.sw),
                  ),
          child: Ink(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.pill),
              border: Border.all(color: surfaces.hairline),
            ),
            child: Icon(Icons.share_outlined, size: 19, color: surfaces.ink),
          ),
        ),
      ),
    );
  }
}

/// Row in the Mahubiri list: poster on the left, title block on the right.
class SermonRow extends StatelessWidget {
  const SermonRow({super.key, required this.sermon});
  final Sermon sermon;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = S(store.localeCode);
    final surfaces = Surfaces.of(context);
    final id = youtubeVideoId(sermon.mediaUrl);
    final cong = store.data.congregationById(sermon.congregationId);

    return AppCard(
      padding: const EdgeInsets.all(Insets.md),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SermonPlayerScreen(sermon: sermon)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 124,
            child: YoutubeThumb(videoId: id, live: sermon.isLive),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sermon.title(store.sw),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: surfaces.ink,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      height: 1.25),
                ),
                const SizedBox(height: Insets.xs),
                Text(
                  sermon.preacher(store.sw),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: surfaces.muted, fontSize: 12.5),
                ),
                Text(
                  [
                    formatDate(sermon.date, store.localeCode),
                    if (cong != null) cong.name(store.sw),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: surfaces.muted, fontSize: 11.5),
                ),
                const SizedBox(height: Insets.sm),
                Row(
                  children: [
                    Text(
                      id != null ? s.watchInApp : s.openMedia,
                      style: TextStyle(
                          color: accentOf(context),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: Insets.xs),
                    Icon(Icons.arrow_forward,
                        size: 13, color: accentOf(context)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
