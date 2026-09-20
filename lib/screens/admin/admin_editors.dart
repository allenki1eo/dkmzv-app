import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/models.dart';
import '../../data/store.dart';
import '../../widgets/common.dart';

const _uuid = Uuid();

Future<void> _confirmDelete(
    BuildContext context, String label, Future<void> Function() onYes) async {
  final s = sOf(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      content: Text(s.confirmDelete),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel)),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.delete)),
      ],
    ),
  );
  if (ok == true) await onYes();
}

class AdminAnnouncements extends StatelessWidget {
  const AdminAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.announcements)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final a in store.data.sortedAnnouncements)
            ListTile(
              title: Text(a.title(store.sw)),
              subtitle: Text(a.date),
              onTap: () => _edit(context, a),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    _confirmDelete(context, a.id, () => store.deleteAnnouncement(a.id)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, Announcement? existing) async {
    final store = context.read<ChurchStore>();
    final item = existing ??
        Announcement(
          id: _uuid.v4(),
          pinned: false,
          date: DateTime.now().toIso8601String().substring(0, 10),
          titleSw: '',
          titleEn: '',
          bodySw: '',
          bodyEn: '',
        );
    final pinned = ValueNotifier(item.pinned);
    final date = TextEditingController(text: item.date);
    final tSw = TextEditingController(text: item.titleSw);
    final tEn = TextEditingController(text: item.titleEn);
    final bSw = TextEditingController(text: item.bodySw);
    final bEn = TextEditingController(text: item.bodyEn);
    final s = sOf(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? s.add : s.edit),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: pinned,
                  builder: (_, v, _) => SwitchListTile(
                    title: Text(s.pinned),
                    value: v,
                    onChanged: (n) => pinned.value = n,
                  ),
                ),
                TextField(controller: date, decoration: InputDecoration(labelText: s.date)),
                TextField(controller: tSw, decoration: InputDecoration(labelText: s.titleSw)),
                TextField(controller: tEn, decoration: InputDecoration(labelText: s.titleEn)),
                TextField(controller: bSw, maxLines: 3, decoration: InputDecoration(labelText: s.bodySw)),
                TextField(controller: bEn, maxLines: 3, decoration: InputDecoration(labelText: s.bodyEn)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(s.save)),
        ],
      ),
    );
    if (ok == true) {
      await store.upsertAnnouncement(Announcement(
        id: item.id,
        pinned: pinned.value,
        date: date.text.trim(),
        titleSw: tSw.text.trim(),
        titleEn: tEn.text.trim(),
        bodySw: bSw.text.trim(),
        bodyEn: bEn.text.trim(),
      ));
    }
  }
}

class AdminServices extends StatelessWidget {
  const AdminServices({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.tabIbada)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final a in store.data.services)
            ListTile(
              title: Text(a.theme(store.sw)),
              subtitle: Text(a.date),
              onTap: () => _edit(context, a),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    _confirmDelete(context, a.id, () => store.deleteService(a.id)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, ServiceOrder? existing) async {
    final store = context.read<ChurchStore>();
    final item = existing ??
        ServiceOrder(
          id: _uuid.v4(),
          date: DateTime.now().toIso8601String().substring(0, 10),
          liturgicalColor: 'green',
          themeSw: '',
          themeEn: '',
          sermonTitleSw: '',
          sermonTitleEn: '',
          preacherSw: '',
          preacherEn: '',
          readings: [],
          outlineSw: [],
          outlineEn: [],
          hymnIds: [],
          bulletinUrl: '',
          bulletinNoteSw: '',
          bulletinNoteEn: '',
        );
    final date = TextEditingController(text: item.date);
    final color = TextEditingController(text: item.liturgicalColor);
    final thSw = TextEditingController(text: item.themeSw);
    final thEn = TextEditingController(text: item.themeEn);
    final seSw = TextEditingController(text: item.sermonTitleSw);
    final seEn = TextEditingController(text: item.sermonTitleEn);
    final prSw = TextEditingController(text: item.preacherSw);
    final prEn = TextEditingController(text: item.preacherEn);
    final readings = TextEditingController(
        text: item.readings.map((r) => '${r.labelSw}|${r.labelEn}|${r.ref}').join('\n'));
    final outSw = TextEditingController(text: item.outlineSw.join('\n'));
    final outEn = TextEditingController(text: item.outlineEn.join('\n'));
    final hymns = TextEditingController(text: item.hymnIds.join(','));
    final url = TextEditingController(text: item.bulletinUrl);
    final bnSw = TextEditingController(text: item.bulletinNoteSw);
    final bnEn = TextEditingController(text: item.bulletinNoteEn);
    final s = sOf(context);
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(existing == null ? s.add : s.edit)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(controller: date, decoration: InputDecoration(labelText: s.date)),
              TextField(controller: color, decoration: const InputDecoration(labelText: 'green/purple/gold/white/red')),
              TextField(controller: thSw, decoration: InputDecoration(labelText: '${s.theme} SW')),
              TextField(controller: thEn, decoration: InputDecoration(labelText: '${s.theme} EN')),
              TextField(controller: seSw, decoration: InputDecoration(labelText: '${s.sermons} SW')),
              TextField(controller: seEn, decoration: InputDecoration(labelText: '${s.sermons} EN')),
              TextField(controller: prSw, decoration: InputDecoration(labelText: '${s.preacher} SW')),
              TextField(controller: prEn, decoration: InputDecoration(labelText: '${s.preacher} EN')),
              TextField(controller: readings, maxLines: 4, decoration: const InputDecoration(labelText: 'Readings SW|EN|ref')),
              TextField(controller: outSw, maxLines: 4, decoration: InputDecoration(labelText: '${s.outline} SW')),
              TextField(controller: outEn, maxLines: 4, decoration: InputDecoration(labelText: '${s.outline} EN')),
              TextField(controller: hymns, decoration: const InputDecoration(labelText: 'Hymn IDs comma-separated')),
              TextField(controller: url, decoration: InputDecoration(labelText: s.mediaUrl)),
              TextField(controller: bnSw, decoration: InputDecoration(labelText: '${s.bulletin} SW')),
              TextField(controller: bnEn, decoration: InputDecoration(labelText: '${s.bulletin} EN')),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(s.save),
              ),
            ],
          ),
        ),
      ),
    );
    if (ok == true) {
      await store.upsertService(ServiceOrder(
        id: item.id,
        date: date.text.trim(),
        liturgicalColor: color.text.trim(),
        themeSw: thSw.text.trim(),
        themeEn: thEn.text.trim(),
        sermonTitleSw: seSw.text.trim(),
        sermonTitleEn: seEn.text.trim(),
        preacherSw: prSw.text.trim(),
        preacherEn: prEn.text.trim(),
        readings: readings.text
            .split('\n')
            .where((l) => l.trim().isNotEmpty)
            .map((l) {
          final p = l.split('|');
          return Reading(
            labelSw: p.isNotEmpty ? p[0] : '',
            labelEn: p.length > 1 ? p[1] : '',
            ref: p.length > 2 ? p[2] : '',
          );
        }).toList(),
        outlineSw: outSw.text.split('\n').where((e) => e.trim().isNotEmpty).toList(),
        outlineEn: outEn.text.split('\n').where((e) => e.trim().isNotEmpty).toList(),
        hymnIds: hymns.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        bulletinUrl: url.text.trim(),
        bulletinNoteSw: bnSw.text.trim(),
        bulletinNoteEn: bnEn.text.trim(),
      ));
    }
  }
}

class AdminEvents extends StatelessWidget {
  const AdminEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.tabEvents)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final a in store.data.events)
            ListTile(
              title: Text(a.title(store.sw)),
              subtitle: Text('${a.category} · ${a.start}'),
              onTap: () => _edit(context, a),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    _confirmDelete(context, a.id, () => store.deleteEvent(a.id)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, ChurchEvent? existing) async {
    final store = context.read<ChurchStore>();
    final item = existing ??
        ChurchEvent(
          id: _uuid.v4(),
          category: 'worship',
          start: DateTime.now().toIso8601String(),
          end: DateTime.now().toIso8601String(),
          titleSw: '',
          titleEn: '',
          placeSw: '',
          placeEn: '',
          detailSw: '',
          detailEn: '',
        );
    final cat = TextEditingController(text: item.category);
    final start = TextEditingController(text: item.start);
    final end = TextEditingController(text: item.end);
    final tSw = TextEditingController(text: item.titleSw);
    final tEn = TextEditingController(text: item.titleEn);
    final pSw = TextEditingController(text: item.placeSw);
    final pEn = TextEditingController(text: item.placeEn);
    final dSw = TextEditingController(text: item.detailSw);
    final dEn = TextEditingController(text: item.detailEn);
    final s = sOf(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? s.add : s.edit),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(children: [
              TextField(controller: cat, decoration: const InputDecoration(labelText: 'worship/choir/uw/youth/confirmation/meeting')),
              TextField(controller: start, decoration: InputDecoration(labelText: '${s.date} start ISO')),
              TextField(controller: end, decoration: const InputDecoration(labelText: 'end ISO')),
              TextField(controller: tSw, decoration: InputDecoration(labelText: s.titleSw)),
              TextField(controller: tEn, decoration: InputDecoration(labelText: s.titleEn)),
              TextField(controller: pSw, decoration: InputDecoration(labelText: '${s.place} SW')),
              TextField(controller: pEn, decoration: InputDecoration(labelText: '${s.place} EN')),
              TextField(controller: dSw, decoration: InputDecoration(labelText: '${s.details} SW')),
              TextField(controller: dEn, decoration: InputDecoration(labelText: '${s.details} EN')),
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(s.save)),
        ],
      ),
    );
    if (ok == true) {
      await store.upsertEvent(ChurchEvent(
        id: item.id,
        category: cat.text.trim(),
        start: start.text.trim(),
        end: end.text.trim(),
        titleSw: tSw.text.trim(),
        titleEn: tEn.text.trim(),
        placeSw: pSw.text.trim(),
        placeEn: pEn.text.trim(),
        detailSw: dSw.text.trim(),
        detailEn: dEn.text.trim(),
      ));
    }
  }
}

class AdminSermons extends StatelessWidget {
  const AdminSermons({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.sermons)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final a in store.data.sermons)
            ListTile(
              title: Text(a.title(store.sw)),
              subtitle: Text(a.date),
              onTap: () => _edit(context, a),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    _confirmDelete(context, a.id, () => store.deleteSermon(a.id)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, Sermon? existing) async {
    final store = context.read<ChurchStore>();
    final item = existing ??
        Sermon(
          id: _uuid.v4(),
          date: DateTime.now().toIso8601String().substring(0, 10),
          titleSw: '',
          titleEn: '',
          preacherSw: '',
          preacherEn: '',
          mediaType: 'youtube',
          mediaUrl: '',
          noteSw: '',
          noteEn: '',
        );
    final date = TextEditingController(text: item.date);
    final tSw = TextEditingController(text: item.titleSw);
    final tEn = TextEditingController(text: item.titleEn);
    final pSw = TextEditingController(text: item.preacherSw);
    final pEn = TextEditingController(text: item.preacherEn);
    final type = TextEditingController(text: item.mediaType);
    final url = TextEditingController(text: item.mediaUrl);
    final nSw = TextEditingController(text: item.noteSw);
    final nEn = TextEditingController(text: item.noteEn);
    final s = sOf(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? s.add : s.edit),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(children: [
              TextField(controller: date, decoration: InputDecoration(labelText: s.date)),
              TextField(controller: tSw, decoration: InputDecoration(labelText: s.titleSw)),
              TextField(controller: tEn, decoration: InputDecoration(labelText: s.titleEn)),
              TextField(controller: pSw, decoration: InputDecoration(labelText: '${s.preacher} SW')),
              TextField(controller: pEn, decoration: InputDecoration(labelText: '${s.preacher} EN')),
              TextField(controller: type, decoration: const InputDecoration(labelText: 'youtube/facebook/audio')),
              TextField(controller: url, decoration: InputDecoration(labelText: s.mediaUrl)),
              TextField(controller: nSw, decoration: InputDecoration(labelText: '${s.note} SW')),
              TextField(controller: nEn, decoration: InputDecoration(labelText: '${s.note} EN')),
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(s.save)),
        ],
      ),
    );
    if (ok == true) {
      await store.upsertSermon(Sermon(
        id: item.id,
        date: date.text.trim(),
        titleSw: tSw.text.trim(),
        titleEn: tEn.text.trim(),
        preacherSw: pSw.text.trim(),
        preacherEn: pEn.text.trim(),
        mediaType: type.text.trim(),
        mediaUrl: url.text.trim(),
        noteSw: nSw.text.trim(),
        noteEn: nEn.text.trim(),
      ));
    }
  }
}

class AdminHymns extends StatelessWidget {
  const AdminHymns({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.tabHymns)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final a in store.data.hymns)
            ListTile(
              leading: Text(a.number),
              title: Text(a.title(store.sw)),
              onTap: () => _edit(context, a),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    _confirmDelete(context, a.id, () => store.deleteHymn(a.id)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, Hymn? existing) async {
    final store = context.read<ChurchStore>();
    final item = existing ??
        Hymn(
          id: 'hymn-${_uuid.v4().substring(0, 8)}',
          number: '',
          titleSw: '',
          titleEn: '',
          firstLineSw: '',
          source: '',
          tags: const [],
          lyricsSw: '',
          lyricsEn: '',
        );
    final number = TextEditingController(text: item.number);
    final tSw = TextEditingController(text: item.titleSw);
    final tEn = TextEditingController(text: item.titleEn);
    final first = TextEditingController(text: item.firstLineSw);
    final source = TextEditingController(text: item.source);
    final tags = TextEditingController(text: item.tags.join(','));
    final lSw = TextEditingController(text: item.lyricsSw);
    final lEn = TextEditingController(text: item.lyricsEn);
    final s = sOf(context);
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(existing == null ? s.add : s.edit)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(controller: number, decoration: InputDecoration(labelText: s.number)),
              TextField(controller: tSw, decoration: InputDecoration(labelText: s.titleSw)),
              TextField(controller: tEn, decoration: InputDecoration(labelText: s.titleEn)),
              TextField(controller: first, decoration: const InputDecoration(labelText: 'First line SW')),
              TextField(controller: source, decoration: InputDecoration(labelText: s.hymnSource)),
              TextField(controller: tags, decoration: const InputDecoration(labelText: 'tags')),
              TextField(controller: lSw, maxLines: 8, decoration: InputDecoration(labelText: s.lyricsSw)),
              TextField(controller: lEn, maxLines: 8, decoration: InputDecoration(labelText: s.lyricsEn)),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(s.save)),
            ],
          ),
        ),
      ),
    );
    if (ok == true) {
      await store.upsertHymn(Hymn(
        id: item.id,
        number: number.text.trim(),
        titleSw: tSw.text.trim(),
        titleEn: tEn.text.trim(),
        firstLineSw: first.text.trim(),
        source: source.text.trim(),
        tags: tags.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        lyricsSw: lSw.text,
        lyricsEn: lEn.text,
      ));
    }
  }
}

class AdminGiving extends StatelessWidget {
  const AdminGiving({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final g = store.data.giving;
    final s = sOf(context);
    final paybill = TextEditingController(text: g.paybill);
    final account = TextEditingController(text: g.account);
    final name = TextEditingController(text: g.accountName);
    final till = TextEditingController(text: g.till);
    final nSw = TextEditingController(text: g.lipaNoteSw);
    final nEn = TextEditingController(text: g.lipaNoteEn);
    final stepsSw = TextEditingController(text: g.stepsSw.join('\n'));
    final stepsEn = TextEditingController(text: g.stepsEn.join('\n'));
    final tips = TextEditingController(text: g.tips.join(','));
    return Scaffold(
      appBar: AppBar(title: Text(s.givingAdmin)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: paybill, decoration: InputDecoration(labelText: s.paybill)),
          TextField(controller: account, decoration: InputDecoration(labelText: s.account)),
          TextField(controller: name, decoration: InputDecoration(labelText: s.accountName)),
          TextField(controller: till, decoration: InputDecoration(labelText: s.till)),
          TextField(controller: nSw, maxLines: 2, decoration: InputDecoration(labelText: '${s.note} SW')),
          TextField(controller: nEn, maxLines: 2, decoration: InputDecoration(labelText: '${s.note} EN')),
          TextField(controller: stepsSw, maxLines: 5, decoration: InputDecoration(labelText: '${s.steps} SW')),
          TextField(controller: stepsEn, maxLines: 5, decoration: InputDecoration(labelText: '${s.steps} EN')),
          TextField(controller: tips, decoration: InputDecoration(labelText: s.amountTips)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await store.saveGiving(GivingConfig(
                paybill: paybill.text.trim(),
                account: account.text.trim(),
                accountName: name.text.trim(),
                till: till.text.trim(),
                lipaNoteSw: nSw.text.trim(),
                lipaNoteEn: nEn.text.trim(),
                stepsSw: stepsSw.text.split('\n').where((e) => e.trim().isNotEmpty).toList(),
                stepsEn: stepsEn.text.split('\n').where((e) => e.trim().isNotEmpty).toList(),
                tips: tips.text
                    .split(',')
                    .map((e) => int.tryParse(e.trim()) ?? 0)
                    .where((e) => e > 0)
                    .toList(),
                purposes: g.purposes,
              ));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.saved)));
              }
            },
            child: Text(s.save),
          ),
        ],
      ),
    );
  }
}

class AdminSundays extends StatelessWidget {
  const AdminSundays({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.sundayAdmin)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (final a in store.data.sundayTimes)
            ListTile(
              title: Text('${a.time} ${a.title(store.sw)}'),
              onTap: () => _edit(context, a),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    _confirmDelete(context, a.id, () => store.deleteSunday(a.id)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, SundaySlot? existing) async {
    final store = context.read<ChurchStore>();
    final item = existing ??
        SundaySlot(id: _uuid.v4(), time: '10:00', titleSw: '', titleEn: '', noteSw: '', noteEn: '');
    final time = TextEditingController(text: item.time);
    final tSw = TextEditingController(text: item.titleSw);
    final tEn = TextEditingController(text: item.titleEn);
    final nSw = TextEditingController(text: item.noteSw);
    final nEn = TextEditingController(text: item.noteEn);
    final s = sOf(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(children: [
            TextField(controller: time, decoration: InputDecoration(labelText: s.time)),
            TextField(controller: tSw, decoration: InputDecoration(labelText: s.titleSw)),
            TextField(controller: tEn, decoration: InputDecoration(labelText: s.titleEn)),
            TextField(controller: nSw, decoration: InputDecoration(labelText: '${s.note} SW')),
            TextField(controller: nEn, decoration: InputDecoration(labelText: '${s.note} EN')),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(s.save)),
        ],
      ),
    );
    if (ok == true) {
      await store.upsertSunday(SundaySlot(
        id: item.id,
        time: time.text.trim(),
        titleSw: tSw.text.trim(),
        titleEn: tEn.text.trim(),
        noteSw: nSw.text.trim(),
        noteEn: nEn.text.trim(),
      ));
    }
  }
}

class AdminContacts extends StatelessWidget {
  const AdminContacts({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.contactsAdmin)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(s.notDirectory),
          ),
          for (final a in store.data.contacts)
            ListTile(
              title: Text(a.role(store.sw)),
              subtitle: Text(a.phone),
              onTap: () => _edit(context, a),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () =>
                    _confirmDelete(context, a.id, () => store.deleteContact(a.id)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, RoleContact? existing) async {
    final store = context.read<ChurchStore>();
    final item = existing ??
        RoleContact(
          id: _uuid.v4(),
          roleSw: '',
          roleEn: '',
          nameSw: '',
          nameEn: '',
          phone: '+255 700 000 000',
          email: '',
          noteSw: '',
          noteEn: '',
        );
    final rSw = TextEditingController(text: item.roleSw);
    final rEn = TextEditingController(text: item.roleEn);
    final nSw = TextEditingController(text: item.nameSw);
    final nEn = TextEditingController(text: item.nameEn);
    final phone = TextEditingController(text: item.phone);
    final email = TextEditingController(text: item.email);
    final noteSw = TextEditingController(text: item.noteSw);
    final noteEn = TextEditingController(text: item.noteEn);
    final s = sOf(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(children: [
            TextField(controller: rSw, decoration: const InputDecoration(labelText: 'Role SW')),
            TextField(controller: rEn, decoration: const InputDecoration(labelText: 'Role EN')),
            TextField(controller: nSw, decoration: InputDecoration(labelText: '${s.yourName} SW')),
            TextField(controller: nEn, decoration: InputDecoration(labelText: '${s.yourName} EN')),
            TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone (role / office)')),
            TextField(controller: email, decoration: InputDecoration(labelText: s.email)),
            TextField(controller: noteSw, decoration: InputDecoration(labelText: '${s.note} SW')),
            TextField(controller: noteEn, decoration: InputDecoration(labelText: '${s.note} EN')),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(s.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(s.save)),
        ],
      ),
    );
    if (ok == true) {
      await store.upsertContact(RoleContact(
        id: item.id,
        roleSw: rSw.text.trim(),
        roleEn: rEn.text.trim(),
        nameSw: nSw.text.trim(),
        nameEn: nEn.text.trim(),
        phone: phone.text.trim(),
        email: email.text.trim(),
        noteSw: noteSw.text.trim(),
        noteEn: noteEn.text.trim(),
      ));
    }
  }
}

class AdminChurch extends StatelessWidget {
  const AdminChurch({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final c = store.data.church;
    final s = sOf(context);
    final nameSw = TextEditingController(text: c.nameSw);
    final nameEn = TextEditingController(text: c.nameEn);
    final addrSw = TextEditingController(text: c.addressSw);
    final addrEn = TextEditingController(text: c.addressEn);
    final map = TextEditingController(text: c.mapUrl);
    final hoursSw = TextEditingController(text: c.officeHoursSw);
    final hoursEn = TextEditingController(text: c.officeHoursEn);
    final aboutSw = TextEditingController(text: c.aboutSw);
    final aboutEn = TextEditingController(text: c.aboutEn);
    final waSw = TextEditingController(text: c.whatsappNoteSw);
    final waEn = TextEditingController(text: c.whatsappNoteEn);
    return Scaffold(
      appBar: AppBar(title: Text(s.churchAdmin)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: nameSw, decoration: InputDecoration(labelText: s.titleSw)),
          TextField(controller: nameEn, decoration: InputDecoration(labelText: s.titleEn)),
          TextField(controller: addrSw, decoration: const InputDecoration(labelText: 'Address SW')),
          TextField(controller: addrEn, decoration: const InputDecoration(labelText: 'Address EN')),
          TextField(controller: map, decoration: InputDecoration(labelText: s.map)),
          TextField(controller: hoursSw, maxLines: 2, decoration: InputDecoration(labelText: '${s.officeHours} SW')),
          TextField(controller: hoursEn, maxLines: 2, decoration: InputDecoration(labelText: '${s.officeHours} EN')),
          TextField(controller: aboutSw, maxLines: 3, decoration: InputDecoration(labelText: '${s.about} SW')),
          TextField(controller: aboutEn, maxLines: 3, decoration: InputDecoration(labelText: '${s.about} EN')),
          TextField(controller: waSw, maxLines: 2, decoration: const InputDecoration(labelText: 'WhatsApp note SW')),
          TextField(controller: waEn, maxLines: 2, decoration: const InputDecoration(labelText: 'WhatsApp note EN')),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await store.saveChurch(ChurchInfo(
                nameSw: nameSw.text.trim(),
                nameEn: nameEn.text.trim(),
                shortName: c.shortName,
                denominationSw: c.denominationSw,
                denominationEn: c.denominationEn,
                dioceseSw: c.dioceseSw,
                dioceseEn: c.dioceseEn,
                addressSw: addrSw.text.trim(),
                addressEn: addrEn.text.trim(),
                mapUrl: map.text.trim(),
                latitude: c.latitude,
                longitude: c.longitude,
                officeHoursSw: hoursSw.text.trim(),
                officeHoursEn: hoursEn.text.trim(),
                whatsappNoteSw: waSw.text.trim(),
                whatsappNoteEn: waEn.text.trim(),
                aboutSw: aboutSw.text.trim(),
                aboutEn: aboutEn.text.trim(),
              ));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.saved)));
              }
            },
            child: Text(s.save),
          ),
        ],
      ),
    );
  }
}
