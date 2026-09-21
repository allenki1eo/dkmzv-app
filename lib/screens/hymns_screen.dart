import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import 'hymn_detail_screen.dart';

class HymnsScreen extends StatefulWidget {
  const HymnsScreen({super.key});

  @override
  State<HymnsScreen> createState() => _HymnsScreenState();
}

class _HymnsScreenState extends State<HymnsScreen> {
  final _q = TextEditingController();

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final results = store.hymnsMatching(_q.text);

    return Scaffold(
      appBar: BrandAppBar(title: s.tabHymns),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _q,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: s.searchHymns,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                if (_q.text.isEmpty && store.favoriteHymns.isNotEmpty) ...[
                  SectionLabel(s.favorites),
                  for (final h in store.favoriteHymns)
                    _HymnTile(hymn: h, favorite: true),
                ],
                if (_q.text.isEmpty && store.recentHymns.isNotEmpty) ...[
                  SectionLabel(s.recent),
                  for (final h in store.recentHymns)
                    _HymnTile(
                      hymn: h,
                      favorite: store.isFavorite(h.id),
                    ),
                ],
                SectionLabel(s.allHymns),
                if (results.isEmpty) EmptyState(s.noHymns),
                for (final h in results)
                  _HymnTile(hymn: h, favorite: store.isFavorite(h.id)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HymnTile extends StatelessWidget {
  const _HymnTile({required this.hymn, required this.favorite});
  final Hymn hymn;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    final store = context.read<ChurchStore>();
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: store.palette.cloth.withValues(alpha: 0.1),
          child: Text(hymn.number,
              style: TextStyle(
                  color: store.palette.cloth,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
        ),
        title: Text(hymn.title(store.sw)),
        subtitle: Text(hymn.firstLineSw, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          color: favorite ? DkmzvBrand.red : Surfaces.of(context).muted,
        ),
        onTap: () {
          store.openHymn(hymn.id);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => HymnDetailScreen(hymn: hymn),
          ));
        },
      ),
    );
  }
}
