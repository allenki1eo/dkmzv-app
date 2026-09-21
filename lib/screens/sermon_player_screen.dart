import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../data/youtube.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

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
    final ser = widget.sermon;
    final cong = store.data.congregationById(ser.congregationId);

    return Scaffold(
      appBar: AppBar(
        title: Text(ser.title(store.sw)),
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
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          if (ser.isLive)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _LiveBadge(label: s.liveNow),
              ),
            ),
          Text(formatDate(ser.date, store.localeCode),
              style: TextStyle(color: Surfaces.of(context).muted, fontSize: 12)),
          Text(ser.title(store.sw),
              style: Theme.of(context).textTheme.titleLarge),
          Text('${s.preacher}: ${ser.preacher(store.sw)}'),
          if (cong != null)
            Text(cong.name(store.sw),
                style: TextStyle(color: Surfaces.of(context).muted)),
          if (ser.note(store.sw).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(ser.note(store.sw),
                style: TextStyle(
                    color: Surfaces.of(context).muted, height: 1.4)),
          ],
          const SizedBox(height: 16),
          if (_web != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: WebViewWidget(controller: _web!),
              ),
            )
          else ...[
            Text(s.youtubeNeedUrl,
                style: TextStyle(
                    color: Surfaces.of(context).muted, height: 1.4)),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: ser.mediaUrl.isEmpty
                ? null
                : () => openExternal(context, ser.mediaUrl, s),
            icon: const Icon(Icons.open_in_new),
            label: Text(s.watchYoutube),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: ser.mediaUrl.isEmpty
                ? null
                : () => shareText(
                      '${ser.title(store.sw)}\n${ser.mediaUrl}',
                      subject: ser.title(store.sw),
                    ),
            icon: const Icon(Icons.share_outlined),
            label: Text(s.shareLink),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: DkmzvBrand.red,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }
}
