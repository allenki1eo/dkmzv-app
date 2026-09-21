import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/store.dart';
import '../../theme/brand.dart';
import '../../widgets/common.dart';
import 'admin_editors.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final unread =
        store.data.pastoralRequests.where((r) => !r.read).length;
    return Scaffold(
      appBar: AppBar(title: Text(s.admin)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _nav(context, s.announcements, store.data.announcements.length,
              () => const AdminAnnouncements()),
          _nav(context, s.tabIbada, store.data.services.length,
              () => const AdminServices()),
          _nav(context, s.tabEvents, store.data.events.length,
              () => const AdminEvents()),
          _nav(context, s.sermons, store.data.sermons.length,
              () => const AdminSermons()),
          _nav(context, s.membersAdmin, store.data.members.length,
              () => const AdminMembers()),
          _nav(context, s.homePins, store.data.homePins.length,
              () => const AdminHomePins()),
          _nav(context, s.tabHymns, store.data.hymns.length,
              () => const AdminHymns()),
          _nav(context, s.givingAdmin, 1, () => const AdminGiving()),
          _nav(context, s.sundayAdmin, store.data.sundayTimes.length,
              () => const AdminSundays()),
          _nav(context, s.contactsAdmin, store.data.contacts.length,
              () => const AdminContacts()),
          _nav(context, s.churchAdmin, 1, () => const AdminChurch()),
          _nav(context, s.inbox, unread, () => const AdminInbox(),
              highlight: unread > 0),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.password),
            title: Text(s.changePin),
            onTap: () => _changePin(context, store, s),
          ),
          ListTile(
            leading: const Icon(Icons.restore, color: Color(0xFF9B1D2E)),
            title: Text(s.resetSeed),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  content: Text(s.resetSeedConfirm),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(s.cancel)),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(s.resetSeed)),
                  ],
                ),
              );
              if (ok == true) await store.restoreSeed();
            },
          ),
        ],
      ),
    );
  }

  Widget _nav(BuildContext context, String title, int count,
      Widget Function() page,
      {bool highlight = false}) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: CircleAvatar(
          radius: 14,
          backgroundColor:
              highlight ? DkmzvBrand.gold : DkmzvBrand.purple.withValues(alpha: 0.1),
          child: Text('$count',
              style: TextStyle(
                  fontSize: 12,
                  color: highlight ? DkmzvBrand.purple : DkmzvBrand.ink,
                  fontWeight: FontWeight.w700)),
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => page()),
        ),
      ),
    );
  }

  Future<void> _changePin(BuildContext context, ChurchStore store, dynamic s) async {
    final c = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.changePin as String),
        content: TextField(
          controller: c,
          obscureText: true,
          decoration: InputDecoration(labelText: s.newPin as String),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel as String)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(s.save as String)),
        ],
      ),
    );
    if (ok == true && c.text.trim().isNotEmpty) {
      await store.changePin(c.text);
    }
  }
}

class AdminInbox extends StatelessWidget {
  const AdminInbox({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final items = store.data.pastoralRequests;
    return Scaffold(
      appBar: AppBar(title: Text(s.inbox)),
      body: items.isEmpty
          ? Center(child: Text(s.emptyInbox))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final r = items[i];
                return Card(
                  color: r.read ? null : DkmzvBrand.gold.withValues(alpha: 0.12),
                  child: ListTile(
                    title: Text('${r.name} · ${r.type}'),
                    subtitle: Text(
                        '${formatDateTime(r.at, store.localeCode)}\n${r.phone}\n${r.message}'),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'read') store.markPastoralRead(r.id);
                        if (v == 'del') store.deletePastoral(r.id);
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'read', child: Text(s.markRead)),
                        PopupMenuItem(value: 'del', child: Text(s.delete)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
