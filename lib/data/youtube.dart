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

/// Poster frame for a video. Served by YouTube itself, so nothing is stored in
/// the APK and nothing is fetched until a list actually shows the sermon.
String youtubeThumbUrl(String videoId, {bool large = true}) =>
    'https://i.ytimg.com/vi/$videoId/${large ? 'hqdefault' : 'mqdefault'}.jpg';

/// Channel id (`UC…`) out of a channel URL, or the bare id if that is what was
/// pasted. Handles (`@dkmzv`) are *not* channel ids — see [youtubeHandle].
String? youtubeChannelId(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return null;
  if (RegExp(r'^UC[\w-]{22}$').hasMatch(value)) return value;
  final uri = Uri.tryParse(value);
  if (uri == null) return null;
  final segs = uri.pathSegments;
  for (var i = 0; i < segs.length; i++) {
    if (segs[i] == 'channel' && i + 1 < segs.length) {
      final id = segs[i + 1].split(RegExp(r'[?&/#]')).first;
      if (RegExp(r'^UC[\w-]{22}$').hasMatch(id)) return id;
    }
  }
  return null;
}

/// `@handle` out of a channel URL or a typed handle.
String? youtubeHandle(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return null;
  if (RegExp(r'^@[\w.-]{3,30}$').hasMatch(value)) return value;
  final uri = Uri.tryParse(value);
  if (uri == null) return null;
  for (final seg in uri.pathSegments) {
    if (seg.startsWith('@') && RegExp(r'^@[\w.-]{3,30}$').hasMatch(seg)) {
      return seg;
    }
  }
  return null;
}

/// Whatever the office pasted, reduced to the bit we can act on.
String normaliseChannel(String raw) =>
    youtubeChannelId(raw) ?? youtubeHandle(raw) ?? '';

/// Plays whatever the channel is streaming right now, without anybody pasting
/// this Sunday's video id. Only works with a `UC…` channel id.
String? youtubeChannelLiveEmbedUrl(String channel) {
  final id = youtubeChannelId(channel);
  if (id == null) return null;
  return 'https://www.youtube.com/embed/live_stream?channel=$id&playsinline=1';
}

/// The channel's live page, for opening in the YouTube app.
String? youtubeChannelLiveUrl(String channel) {
  final handle = youtubeHandle(channel);
  if (handle != null) return 'https://www.youtube.com/$handle/live';
  final id = youtubeChannelId(channel);
  if (id != null) return 'https://www.youtube.com/channel/$id/live';
  return null;
}
