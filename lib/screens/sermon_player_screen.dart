import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../data/youtube.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/video.dart';

class SermonPlayerScreen extends StatefulWidget {
  const SermonPlayerScreen({super.key, required this.sermon});
  final Sermon sermon;

  @override
  State<SermonPlayerScreen> createState() => _SermonPlayerScreenState();
}

class _SermonPlayerScreenState extends State<SermonPlayerScreen> {
  WebViewController? _web;

  @override
  void initState() {
    super.initState();
    final id = youtubeVideoId(widget.sermon.mediaUrl);
    if (id != null) {
      _web = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF000000))
        ..loadRequest(Uri.parse(youtubeEmbedUrl(id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final ser = widget.sermon;
    final cong = store.data.congregationById(ser.congregationId);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.sermons),
        actions: [
          IconButton(
            tooltip: s.shareLink,
            onPressed: ser.mediaUrl.isEmpty
                ? null
                : () => shareText(
                      '${ser.title(store.sw)}\n${ser.mediaUrl}',
                      subject: ser.title(store.sw),
                    ),
            icon: const Icon(Icons.share_outlined),
          ),
          const SizedBox(width: Insets.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Insets.gutter, Insets.sm, Insets.gutter, Insets.xxl),
        children: [
          if (_web != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(Radii.md),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: WebViewWidget(controller: _web!),
              ),
            )
          else
            AppCard(
              padding: const EdgeInsets.all(Insets.lg),
              child: Row(
                children: [
                  Icon(Icons.link_off, color: surfaces.muted, size: 20),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Text(s.youtubeNeedUrl,
                        style: TextStyle(
                            color: surfaces.muted, fontSize: 13, height: 1.45)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: Insets.lg),
          if (ser.isLive) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: LiveBadge(label: s.liveNow),
            ),
            const SizedBox(height: Insets.sm),
          ],
          Text(ser.title(store.sw),
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: Insets.xs),
          Text(
            [
              ser.preacher(store.sw),
              formatDate(ser.date, store.localeCode),
              if (cong != null) cong.name(store.sw),
            ].where((e) => e.isNotEmpty).join(' · '),
            style: TextStyle(color: surfaces.muted, fontSize: 13),
          ),
          if (ser.note(store.sw).isNotEmpty) ...[
            const SizedBox(height: Insets.md),
            Text(ser.note(store.sw),
                style: TextStyle(
                    color: surfaces.muted, fontSize: 13.5, height: 1.5)),
          ],
          const SizedBox(height: Insets.xl),
          FilledButton.icon(
            onPressed: ser.mediaUrl.isEmpty
                ? null
                : () => openExternal(context, ser.mediaUrl, s),
            icon: const Icon(Icons.open_in_new, size: 19),
            label: Text(s.watchYoutube),
          ),
          const SizedBox(height: Insets.md),
          OutlinedButton.icon(
            onPressed: ser.mediaUrl.isEmpty
                ? null
                : () => shareText(
                      '${ser.title(store.sw)}\n${ser.mediaUrl}',
                      subject: ser.title(store.sw),
                    ),
            icon: const Icon(Icons.share_outlined, size: 19),
            label: Text(s.shareLink),
          ),
        ],
      ),
    );
  }
}
