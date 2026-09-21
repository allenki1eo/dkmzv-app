import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../data/youtube.dart';

/// Builds the WebView that plays a YouTube embed inside the app.
///
/// Three things have to be right or the player refuses to start with
/// "Video player configuration error (153)":
///
///  * the embed must sit in an **iframe on a page with a real origin**, not be
///    the top-level document — so the HTML wrapper is loaded with
///    `baseUrl: youtubeEmbedBaseUrl` rather than navigating to the embed URL;
///  * JavaScript must be unrestricted, since the player is entirely JS;
///  * on Android the WebView must be allowed to start media without a
///    separate user gesture, otherwise tapping play does nothing on some
///    devices.
///
/// Returns null when there is nothing playable, so callers can show the
/// "open in YouTube" fallback instead of an empty black box.
WebViewController? buildYoutubePlayer({String? videoId, String? channel}) {
  final String html;
  if (videoId != null) {
    html = youtubeEmbedHtml(videoId);
  } else if (channel != null) {
    final live = youtubeChannelLiveEmbedHtml(channel);
    if (live == null) return null;
    html = live;
  } else {
    return null;
  }

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0xFF000000))
    // YouTube serves the mobile player to a mobile browser UA. The default
    // WebView UA is close enough, but pinning it keeps the player stable
    // across the range of Android WebView versions in the parish.
    ..setUserAgent(
      'Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/120.0.0.0 Mobile Safari/537.36',
    )
    ..loadHtmlString(html, baseUrl: youtubeEmbedBaseUrl);

  final platform = controller.platform;
  if (platform is AndroidWebViewController) {
    platform.setMediaPlaybackRequiresUserGesture(false);
  }

  return controller;
}
