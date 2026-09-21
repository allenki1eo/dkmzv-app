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
    'https://www.youtube.com/embed/$videoId'
    '?playsinline=1&rel=0&modestbranding=1&origin=$_embedOrigin';

/// The origin the in-app player claims. YouTube refuses to configure the
/// player when the embed is the top-level document with no referrer — that is
/// the "Video player configuration error (153)" people hit in a WebView. The
/// embed has to sit in an iframe on a page that has a real origin, so the
/// player is wrapped in [youtubeEmbedHtml] and loaded with this as the base
/// URL.
const String _embedOrigin = 'https://www.youtube.com';

/// Base URL the player HTML must be loaded with, so the WebView reports a
/// real origin to YouTube instead of `about:blank`.
const String youtubeEmbedBaseUrl = _embedOrigin;

String _playerHtml(String src) =>
    '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport"
      content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<style>
  html, body { margin: 0; padding: 0; height: 100%; background: #000; overflow: hidden; }
  .stage { position: absolute; top: 0; left: 0; right: 0; bottom: 0; }
  iframe { display: block; width: 100%; height: 100%; border: 0; }
</style>
</head>
<body>
<div class="stage">
<iframe src="$src"
        frameborder="0"
        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen></iframe>
</div>
</body>
</html>
''';

/// A one-page wrapper that hosts the embed in an iframe.
///
/// Load it with `loadHtmlString(html, baseUrl: youtubeEmbedBaseUrl)`.
String youtubeEmbedHtml(String videoId) =>
    _playerHtml(youtubeEmbedUrl(videoId));

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
  return 'https://www.youtube.com/embed/live_stream'
      '?channel=$id&playsinline=1&rel=0&origin=$_embedOrigin';
}

/// The channel's live stream wrapped for the in-app player, or null when the
/// office only pasted a handle.
String? youtubeChannelLiveEmbedHtml(String channel) {
  final url = youtubeChannelLiveEmbedUrl(channel);
  return url == null ? null : _playerHtml(url);
}

/// The channel's live page, for opening in the YouTube app.
String? youtubeChannelLiveUrl(String channel) {
  final handle = youtubeHandle(channel);
  if (handle != null) return 'https://www.youtube.com/$handle/live';
  final id = youtubeChannelId(channel);
  if (id != null) return 'https://www.youtube.com/channel/$id/live';
  return null;
}
