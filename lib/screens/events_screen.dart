import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../widgets/common.dart';

const _cats = ['all', 'worship', 'choir', 'uw', 'youth', 'confirmation', 'meeting'];

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _cat = 'all';

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final accent = accentOf(context);
    final items = [...store.data.events]
      ..sort((a, b) => a.start.compareTo(b.start));
    final filtered =
        _cat == 'all' ? items : items.where((e) => e.category == _cat).toList();

    return Scaffold(
      appBar: BrandAppBar(title: s.tabEvents),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              children: [
                for (final c in _cats)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _cat == c,
                      label: Text(c == 'all' ? s.filterAll : s.cat(c)),
                      onSelected: (_) => setState(() => _cat = c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text(s.noEvents))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final e = filtered[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DateRailTile(
                          startIso: e.start,
                          title: e.title(store.sw),
                          subtitle:
                              '${formatDateTime(e.start, store.localeCode)} · ${e.place(store.sw)}',
                          accent: accent,
                          onTap: () => showEventSheet(context, e),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
