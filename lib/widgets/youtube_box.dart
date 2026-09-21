import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../data/store.dart';
import '../data/youtube.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../theme/tokens.dart';
import 'common.dart';
import 'video.dart';

/// A 16:9 YouTube surface that is honest about failure.
///
/// Embedded playback is not guaranteed: a video's owner can forbid it, a
/// stream can end, and YouTube can simply refuse to configure the player.
/// When any of that happens this box stops showing YouTube's own error and
/// shows the poster with a button that opens the YouTube app instead — which
/// is what a member wanted anyway.
class YoutubeBox extends StatefulWidget {
  const YoutubeBox({
    super.key,
    this.videoId,
    this.channel,
    required this.openUrl,
    this.live = false,
  });

  /// A single sermon. Takes precedence over [channel].
  final String? videoId;

  /// The parish channel, played as "whatever is streaming now".
  final String? channel;

  /// Where "open in YouTube" should go.
  final String openUrl;

  final bool live;

  @override
  State<YoutubeBox> createState() => _YoutubeBoxState();
}

class _YoutubeBoxState extends State<YoutubeBox> {
  WebViewController? _web;
  Timer? _watchdog;
  bool _ready = false;
  bool _failed = false;

  /// How long to wait for the player to say it is ready before assuming the
  /// embed will never come up. Generous, because parish data is slow.
  static const _timeout = Duration(seconds: 12);

  @override
  void initState() {
    super.initState();
    _build();
  }

  void _build() {
    final String? html;
    if (widget.videoId != null) {
      html = youtubeEmbedHtml(widget.videoId!);
    } else if (widget.channel != null) {
      html = youtubeChannelLiveEmbedHtml(widget.channel!);
    } else {
      html = null;
    }
    if (html == null) {
      _failed = true;
      return;
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..addJavaScriptChannel(
        youtubePlayerChannel,
        onMessageReceived: (message) => _onPlayerMessage(message.message),
      )
      ..setNavigationDelegate(
        NavigationDelegate(onWebResourceError: (_) => _fail()),
      )
      // The base URL is what gives the page a real origin. Without it the
      // player answers "Video player configuration error (153)".
      ..loadHtmlString(html, baseUrl: youtubeEmbedBaseUrl);

    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setMediaPlaybackRequiresUserGesture(false);
    }

    _web = controller;
    _watchdog = Timer(_timeout, () {
      if (!_ready) _fail();
    });
  }

  void _onPlayerMessage(String message) {
    if (message == 'ready') {
      _watchdog?.cancel();
      if (mounted && !_ready) setState(() => _ready = true);
      return;
    }
    if (message.startsWith('error:')) _fail();
  }

  void _fail() {
    _watchdog?.cancel();
    if (mounted && !_failed) setState(() => _failed = true);
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || _web == null) {
      return _Fallback(
        videoId: widget.videoId,
        openUrl: widget.openUrl,
        live: widget.live,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.md),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            WebViewWidget(controller: _web!),
            // Hold the poster over the black WebView until the player says it
            // is ready, so the card never flashes an empty box.
            if (!_ready)
              IgnorePointer(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    YoutubeThumb(videoId: widget.videoId, live: widget.live),
                    const ColoredBox(color: Color(0x33000000)),
                    const Center(
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Poster plus a way out, shown when the embed will not play.
class _Fallback extends StatelessWidget {
  const _Fallback({
    required this.videoId,
    required this.openUrl,
    required this.live,
  });

  final String? videoId;
  final String openUrl;
  final bool live;

  @override
  Widget build(BuildContext context) {
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final canOpen = openUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: canOpen ? () => openExternal(context, openUrl, s) : null,
          child: YoutubeThumb(videoId: videoId, live: live),
        ),
        const SizedBox(height: Insets.sm),
        Row(
          children: [
            Icon(Icons.info_outline, size: 15, color: surfaces.muted),
            const SizedBox(width: Insets.sm),
            Expanded(
              child: Text(
                s.watchOnYoutubeInstead,
                style: TextStyle(
                  color: surfaces.muted,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Convenience for a sermon, which knows its own link.
class SermonPlayerBox extends StatelessWidget {
  const SermonPlayerBox({super.key, required this.mediaUrl, this.live = false});

  final String mediaUrl;
  final bool live;

  @override
  Widget build(BuildContext context) {
    context.watch<ChurchStore>();
    return YoutubeBox(
      videoId: youtubeVideoId(mediaUrl),
      openUrl: mediaUrl,
      live: live,
    );
  }
}
