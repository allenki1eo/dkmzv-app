import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/store.dart';
import '../data/youtube.dart';
import '../services/links.dart';
import '../services/player.dart';
import '../theme/brand.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

/// Plays whatever the parish channel is streaming right now. Nobody has to
/// paste this Sunday's video id — the channel id set once in Msimamizi is
/// enough.
class ChannelLiveScreen extends StatefulWidget {
  const ChannelLiveScreen({super.key});

  @override
  State<ChannelLiveScreen> createState() => _ChannelLiveScreenState();
}

class _ChannelLiveScreenState extends State<ChannelLiveScreen> {
  WebViewController? _web;

  @override
  void initState() {
    super.initState();
    final channel = context.read<ChurchStore>().youtubeChannel;
    _web = buildYoutubePlayer(channel: channel);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final watchUrl = youtubeChannelLiveUrl(store.youtubeChannel);

    return Scaffold(
      appBar: AppBar(title: Text(s.channelLiveTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Insets.gutter,
          Insets.sm,
          Insets.gutter,
          Insets.xxl,
        ),
        children: [
          Text(
            s.channelLiveNote,
            style: TextStyle(color: surfaces.muted, fontSize: 13, height: 1.45),
          ),
          const SizedBox(height: Insets.lg),
          if (_web != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Radii.md),
                child: WebViewWidget(controller: _web!),
              ),
            )
          else
            EmptyState(s.youtubeNeedUrl, icon: Icons.link_off),
          const SizedBox(height: Insets.lg),
          if (watchUrl != null)
            FilledButton.icon(
              onPressed: () => openExternal(context, watchUrl, s),
              icon: const Icon(Icons.open_in_new, size: 19),
              label: Text(s.watchYoutube),
            ),
        ],
      ),
    );
  }
}
