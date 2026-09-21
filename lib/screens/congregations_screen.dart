import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import '../widgets/parish.dart';
import 'jumuiya_map_screen.dart';
import 'sermon_player_screen.dart';

class CongregationsScreen extends StatelessWidget {
  const CongregationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final selected = store.selectedCongregation?.id;

    return Scaffold(
      appBar: AppBar(title: Text(s.congregations)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          Text(s.congregationsLead,
              style: TextStyle(color: surfaces.muted, height: 1.45)),
          const SizedBox(height: 14),
          for (final c in store.data.congregations)
            Builder(builder: (context) {
              final color = accentForBrightness(
                  congregationColor(c), Theme.of(context).brightness);
              final isSelected = selected == c.id;
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(21)),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child:
                                Icon(motifIcon(c.motif), color: color, size: 21),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name(store.sw),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(
                                  c.tagline(store.sw).isEmpty
                                      ? c.role(store.sw)
                                      : c.tagline(store.sw),
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Pill(c.isMain ? s.cathedral : s.sisterChurch,
                              color: c.isMain ? DkmzvBrand.gold : color),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.address(store.sw),
                              style: Theme.of(context).textTheme.bodyMedium),
                          if (c.approximate) ...[
                            const SizedBox(height: 6),
                            FootNote(s.approximatePin,
                                icon: Icons.location_searching),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.tonal(
                                  onPressed: isSelected
                                      ? null
                                      : () => store.selectCongregation(c.id),
                                  child: Text(isSelected
                                      ? s.myCongregation
                                      : s.useThisChurch),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: s.jumuiyaMap,
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        JumuiyaMapScreen(congregationId: c.id),
                                  ),
                                ),
                                icon: const Icon(Icons.map_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

/// Live sermon strip on Home: watch in-app, or share the YouTube link.
class LiveSermonBanner extends StatelessWidget {
  const LiveSermonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final live = store.liveSermon;
    if (live == null) return const SizedBox.shrink();
    final s = sOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: DkmzvBrand.red.withValues(alpha: 0.08),
          border: Border.all(color: DkmzvBrand.red.withValues(alpha: 0.35)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 13, 10, 13),
        child: Row(
          children: [
            const Icon(Icons.podcasts, color: DkmzvBrand.red, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Pill(s.liveNow, color: DkmzvBrand.red, filled: true),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(live.title(store.sw),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => SermonPlayerScreen(sermon: live)),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: Text(s.watchInApp),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        tooltip: s.shareLink,
                        onPressed: () => shareText(
                          '${live.title(store.sw)}\n${live.mediaUrl}',
                          subject: live.title(store.sw),
                        ),
                        icon: const Icon(Icons.share_outlined, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
