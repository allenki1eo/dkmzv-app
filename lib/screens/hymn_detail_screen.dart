import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

class HymnDetailScreen extends StatelessWidget {
  const HymnDetailScreen({super.key, required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final fav = store.isFavorite(hymn.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('${s.tabHymns} ${hymn.number}'),
        actions: [
          IconButton(
            tooltip: fav ? s.favoriteRemove : s.favoriteAdd,
            onPressed: () => store.toggleFavorite(hymn.id),
            icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          Text(hymn.title(store.sw),
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(hymn.title(!store.sw),
              style: const TextStyle(color: DkmzvBrand.muted)),
          const SizedBox(height: 12),
          Text(s.offlineCached,
              style: const TextStyle(color: DkmzvBrand.green, fontSize: 13)),
          const SizedBox(height: 16),
          SelectableText(
            hymn.lyrics(store.sw),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 24),
          Text('${s.hymnSource}: ${hymn.source}',
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 12)),
        ],
      ),
    );
  }
}
