import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import 'jumuiya_map_screen.dart';
import 'sermon_player_screen.dart';

class CongregationsScreen extends StatelessWidget {
  const CongregationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final selected = store.selectedCongregation?.id;

    return Scaffold(
      appBar: AppBar(title: Text(s.congregations)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(s.congregationsLead,
              style: const TextStyle(color: DkmzvBrand.muted, height: 1.4)),
          const SizedBox(height: 12),
          for (final c in store.data.congregations)
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(c.name(store.sw),
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                        if (c.isMain)
                          _pill(s.cathedral, DkmzvBrand.gold)
                        else
                          _pill(s.sisterChurch, DkmzvBrand.sage),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(c.role(store.sw),
                        style: const TextStyle(
                            color: DkmzvBrand.purple,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(c.address(store.sw)),
                    if (c.approximate) ...[
                      const SizedBox(height: 4),
                      Text(s.approximatePin,
                          style: const TextStyle(
                              color: DkmzvBrand.muted, fontSize: 12)),
                    ],
                    if (c.note(store.sw).isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(c.note(store.sw),
                          style: const TextStyle(
                              color: DkmzvBrand.muted, fontSize: 13)),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilledButton.tonal(
                          onPressed: selected == c.id
                              ? null
                              : () => store.selectCongregation(c.id),
                          child: Text(selected == c.id
                              ? s.myCongregation
                              : s.useThisChurch),
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  JumuiyaMapScreen(congregationId: c.id),
                            ),
                          ),
                          icon: const Icon(Icons.map_outlined),
                          label: Text(s.jumuiyaMap),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

/// Live sermon strip used on Home — same v1 card language.
class LiveSermonBanner extends StatelessWidget {
  const LiveSermonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final live = store.liveSermon;
    if (live == null) return const SizedBox.shrink();
    final s = sOf(context);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.podcasts, color: DkmzvBrand.red),
        title: Text(live.title(store.sw)),
        subtitle: Text(s.liveLead),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: DkmzvBrand.red,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(s.liveNow,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800)),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SermonPlayerScreen(sermon: live)),
        ),
      ),
    );
  }
}
