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
    final p = store.palette;
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
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 48),
        children: [
          Text(
            hymn.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: p.metal,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hymn.title(store.sw),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: p.cloth,
                  height: 1.25,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            hymn.title(!store.sw),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: p.cloth.withValues(alpha: 0.55),
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 14),
          Text(s.offlineCached,
              textAlign: TextAlign.center,
              style: TextStyle(color: p.cloth, fontSize: 13)),
          const SizedBox(height: 20),
          SelectableText(
            hymn.lyrics(store.sw),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.7,
                  fontWeight: FontWeight.w500,
                  color: Surfaces.of(context).ink,
                ),
          ),
          const SizedBox(height: 28),
          Text('${s.hymnSource}: ${hymn.source}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: p.cloth.withValues(alpha: 0.5), fontSize: 12)),
        ],
      ),
    );
  }
}
