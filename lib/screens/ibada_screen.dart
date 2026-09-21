import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import 'hymn_detail_screen.dart';

class IbadaScreen extends StatelessWidget {
  const IbadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final services = [...store.data.services]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: BrandAppBar(title: s.tabIbada),
      body: services.isEmpty
          ? Center(child: Text(s.noService))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: services.length,
              itemBuilder: (_, i) {
                final item = services[i];
                final featured = store.featuredService?.id == item.id;
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      store.openIbada(item.id);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => IbadaDetailScreen(service: item),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 56,
                            decoration: BoxDecoration(
                              color: liturgical(item.liturgicalColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(formatDate(item.date, store.localeCode),
                                    style: TextStyle(
                                        color: Surfaces.of(context).muted,
                                        fontSize: 12)),
                                Text(item.theme(store.sw),
                                    style:
                                        Theme.of(context).textTheme.titleMedium),
                                Text(item.sermonTitle(store.sw)),
                                if (featured)
                                  Text(s.offlineCached,
                                      style: const TextStyle(
                                          color: DkmzvBrand.clothGreen,
                                          fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class IbadaDetailScreen extends StatelessWidget {
  const IbadaDetailScreen({super.key, required this.service});
  final ServiceOrder service;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.tabIbada)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(formatDate(service.date, store.localeCode),
              style: TextStyle(color: store.palette.cloth, fontWeight: FontWeight.w600)),
          Text(service.theme(store.sw),
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(service.sermonTitle(store.sw),
              style: Theme.of(context).textTheme.titleMedium),
          Text('${s.preacher}: ${service.preacher(store.sw)}'),
          const SizedBox(height: 8),
          Chip(
            avatar: CircleAvatar(
                backgroundColor: liturgical(service.liturgicalColor)),
            label: Text(
                '${s.liturgicalColor}: ${service.liturgicalColor}'),
          ),
          SectionLabel(s.readings),
          for (final r in service.readings)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(r.label(store.sw)),
              subtitle: Text(r.ref,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: store.palette.cloth)),
            ),
          SectionLabel(s.outline),
          for (var i = 0; i < service.outline(store.sw).length; i++)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: store.palette.cloth,
                child: Text('${i + 1}',
                    style: TextStyle(color: store.palette.onCloth, fontSize: 12)),
              ),
              title: Text(service.outline(store.sw)[i]),
            ),
          if (service.hymnIds.isNotEmpty) ...[
            SectionLabel(s.hymnsInService),
            for (final id in service.hymnIds)
              if (store.data.hymnById(id) case final hymn?)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(hymn.number,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  title: Text(hymn.title(store.sw)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    store.openHymn(hymn.id);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => HymnDetailScreen(hymn: hymn),
                    ));
                  },
                ),
          ],
          SectionLabel(s.bulletin),
          Text(service.bulletinNote(store.sw)),
          if (service.bulletinUrl.isNotEmpty) ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () =>
                  openExternal(context, service.bulletinUrl, s),
              icon: const Icon(Icons.open_in_new),
              label: Text(s.openLink),
            ),
          ],
        ],
      ),
    );
  }
}
