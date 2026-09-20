import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

class SermonsScreen extends StatelessWidget {
  const SermonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final items = [...store.data.sermons]..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: Text(s.sermons)),
      body: items.isEmpty
          ? Center(child: Text(s.noSermons))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final ser = items[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatDate(ser.date, store.localeCode),
                            style: const TextStyle(
                                color: DkmzvBrand.muted, fontSize: 12)),
                        Text(ser.title(store.sw),
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('${s.preacher}: ${ser.preacher(store.sw)}'),
                        if (ser.note(store.sw).isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(ser.note(store.sw),
                              style: const TextStyle(
                                  color: DkmzvBrand.muted, fontSize: 13)),
                        ],
                        const SizedBox(height: 8),
                        FilledButton.tonalIcon(
                          onPressed: ser.mediaUrl.isEmpty
                              ? null
                              : () =>
                                  openExternal(context, ser.mediaUrl, s),
                          icon: const Icon(Icons.play_circle_outline),
                          label: Text(s.openMedia),
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
