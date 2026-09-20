import 'models.dart';

/// Case-insensitive search across number, titles, first line, tags, lyrics.
List<Hymn> searchHymns(Iterable<Hymn> hymns, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return List<Hymn>.from(hymns);
  return hymns.where((h) {
    final blob = [
      h.number,
      h.titleSw,
      h.titleEn,
      h.firstLineSw,
      h.source,
      h.lyricsSw,
      h.lyricsEn,
      ...h.tags,
    ].join(' · ').toLowerCase();
    return blob.contains(q);
  }).toList();
}
