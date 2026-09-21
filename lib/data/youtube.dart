/// Parse a YouTube watch / share / live / shorts URL into an 11-character id.
String? youtubeVideoId(String raw) {
  final url = raw.trim();
  if (url.isEmpty) return null;
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return null;
  final host = uri.host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');

  if (host == 'youtu.be') {
    if (uri.pathSegments.isEmpty) return null;
    return _validId(uri.pathSegments.first);
  }

  const youtubeHosts = {
    'youtube.com',
    'm.youtube.com',
    'music.youtube.com',
    'youtube-nocookie.com',
  };
  if (!youtubeHosts.contains(host)) return null;

  final v = uri.queryParameters['v'];
  if (v != null && v.isNotEmpty) return _validId(v);

  final segs = uri.pathSegments;
  for (var i = 0; i < segs.length; i++) {
    final seg = segs[i];
    if (seg == 'embed' ||
        seg == 'live' ||
        seg == 'shorts' ||
        seg == 'v' ||
        seg == 'e') {
      if (i + 1 >= segs.length) return null;
      if (segs[i + 1] == 'live_stream') return null;
      return _validId(segs[i + 1]);
    }
  }
  return null;
}

String? _validId(String raw) {
  final cleaned = raw.split(RegExp(r'[?&/#]')).first;
  if (RegExp(r'^[\w-]{11}$').hasMatch(cleaned)) return cleaned;
  return null;
}

bool isYoutubeUrl(String raw) => youtubeVideoId(raw) != null;

String youtubeEmbedUrl(String videoId) =>
    'https://www.youtube-nocookie.com/embed/$videoId?playsinline=1&rel=0&modestbranding=1';

String youtubeWatchUrl(String videoId) =>
    'https://www.youtube.com/watch?v=$videoId';
