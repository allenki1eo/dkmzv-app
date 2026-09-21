import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/models.dart';
import '../../data/store.dart';
import '../../data/youtube.dart';
import '../../theme/brand.dart';
import '../../theme/tokens.dart';
import '../../widgets/common.dart';
import '../../widgets/video.dart';

const _uuid = Uuid();

/// The one place the office goes to put a sermon on people's phones: paste the
/// YouTube link, name it, publish — or flip it live.
class AdminYoutube extends StatefulWidget {
  const AdminYoutube({super.key});

  @override
  State<AdminYoutube> createState() => _AdminYoutubeState();
}

class _AdminYoutubeState extends State<AdminYoutube> {
  final _link = TextEditingController();
  final _titleSw = TextEditingController();
  final _titleEn = TextEditingController();
  final _preacher = TextEditingController();
  final _channel = TextEditingController();
  bool _channelDirty = false;

  @override
  void initState() {
    super.initState();
    _channel.text = context.read<ChurchStore>().youtubeChannel;
  }

  @override
  void dispose() {
    _link.dispose();
    _titleSw.dispose();
    _titleEn.dispose();
    _preacher.dispose();
    _channel.dispose();
    super.dispose();
  }

  String? get _videoId => youtubeVideoId(_link.text);

  Future<void> _publish({required bool live}) async {
    final store = context.read<ChurchStore>();
    final s = sOf(context);
    final id = _videoId;
    if (id == null) return;
    final titleSw = _titleSw.text.trim().isEmpty
        ? s.sermons
        : _titleSw.text.trim();
    final sermon = Sermon(
      id: _uuid.v4(),
      date: DateTime.now().toIso8601String().substring(0, 10),
      titleSw: titleSw,
      titleEn: _titleEn.text.trim().isEmpty ? titleSw : _titleEn.text.trim(),
      preacherSw: _preacher.text.trim(),
      preacherEn: _preacher.text.trim(),
      mediaType: 'youtube',
      mediaUrl: youtubeWatchUrl(id),
      noteSw: '',
      noteEn: '',
      isLive: live,
      congregationId: store.selectedCongregation?.id ?? '',
    );
    await store.upsertSermon(sermon);
    if (live) await store.setLiveSermon(sermon.id, true);
    if (!mounted) return;
    _link.clear();
    _titleSw.clear();
    _titleEn.clear();
    _preacher.clear();
    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s.saved)));
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final id = _videoId;
    final typed = _link.text.trim().isNotEmpty;
    final sermons = [...store.data.sermons]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: Text(s.youtubeStudio)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Insets.gutter, Insets.sm, Insets.gutter, Insets.xxl),
        children: [
          Text(s.pasteYoutubeHint,
              style:
                  TextStyle(color: surfaces.muted, fontSize: 13, height: 1.45)),
          const SizedBox(height: Insets.lg),
          TextField(
            controller: _link,
            keyboardType: TextInputType.url,
            autocorrect: false,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: s.pasteYoutube,
              hintText: 'https://youtu.be/…',
              prefixIcon: const Icon(Icons.link, size: 20),
              suffixIcon: !typed
                  ? null
                  : Icon(
                      id != null ? Icons.check_circle : Icons.error_outline,
                      color: id != null ? DkmzvBrand.clothGreen : DkmzvBrand.live,
                      size: 20,
                    ),
            ),
          ),
          if (typed) ...[
            const SizedBox(height: Insets.sm),
            Text(
              id != null ? s.linkLooksGood : s.linkNotYoutube,
              style: TextStyle(
                color: id != null ? surfaces.muted : DkmzvBrand.live,
                fontSize: 12.5,
              ),
            ),
          ],
          if (id != null) ...[
            const SizedBox(height: Insets.lg),
            YoutubeThumb(videoId: id),
            const SizedBox(height: Insets.lg),
            TextField(
              controller: _titleSw,
              decoration: InputDecoration(labelText: s.titleSw),
            ),
            const SizedBox(height: Insets.md),
            TextField(
              controller: _titleEn,
              decoration: InputDecoration(labelText: s.titleEn),
            ),
            const SizedBox(height: Insets.md),
            TextField(
              controller: _preacher,
              decoration: InputDecoration(labelText: s.preacher),
            ),
            const SizedBox(height: Insets.lg),
            FilledButton.icon(
              onPressed: () => _publish(live: false),
              icon: const Icon(Icons.library_add_outlined, size: 19),
              label: Text(s.publishAsSermon),
            ),
            const SizedBox(height: Insets.md),
            OutlinedButton.icon(
              onPressed: () => _publish(live: true),
              icon: const Icon(Icons.sensors, size: 19),
              label: Text(s.startLiveNow),
            ),
          ],
          SectionLabel(s.channelLabel),
          Text(s.channelHint,
              style: TextStyle(
                  color: surfaces.muted, fontSize: 12.5, height: 1.45)),
          const SizedBox(height: Insets.md),
          TextField(
            controller: _channel,
            autocorrect: false,
            onChanged: (_) => setState(() => _channelDirty = true),
            decoration: InputDecoration(
              labelText: s.channelLabel,
              hintText: 'https://youtube.com/@…',
              prefixIcon: const Icon(Icons.podcasts, size: 20),
            ),
          ),
          const SizedBox(height: Insets.md),
          FilledButton(
            onPressed: !_channelDirty
                ? null
                : () async {
                    await store.setYoutubeChannel(_channel.text);
                    if (!context.mounted) return;
                    setState(() => _channelDirty = false);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(s.saved)));
                  },
            child: Text(s.save),
          ),
          if (sermons.isNotEmpty) ...[
            SectionLabel(s.allSermons),
            for (final ser in sermons.take(6))
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: AppCard(
                  padding: const EdgeInsets.fromLTRB(
                      Insets.md, Insets.sm, Insets.sm, Insets.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ser.title(store.sw),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: surfaces.ink,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.5)),
                            Text(
                              youtubeVideoId(ser.mediaUrl) == null
                                  ? s.linkNotYoutube
                                  : formatDate(ser.date, store.localeCode),
                              style: TextStyle(
                                  color: surfaces.muted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: ser.isLive,
                        onChanged: (v) => store.setLiveSermon(ser.id, v),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
