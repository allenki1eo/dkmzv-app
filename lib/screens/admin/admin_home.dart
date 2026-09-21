import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/store.dart';
import '../../data/youtube.dart';
import '../../services/links.dart';
import '../../theme/brand.dart';
import '../../widgets/common.dart';
import '../../widgets/parish.dart';
import 'admin_editors.dart';
import 'admin_parish.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final unread = store.data.pastoralRequests.where((r) => !r.read).length;
    final congregation = store.selectedCongregation;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.admin),
        actions: const [ParishButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          Text(congregation?.name(store.sw) ?? s.churchShort,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95,
            children: [
              StatTile(
                value: '${store.data.members.length}',
                label: s.registeredMembers,
                icon: Icons.people_outline,
                onTap: () => _open(context, const AdminMembers()),
              ),
              StatTile(
                value: '${store.data.jumuiyas.length}',
                label: s.jumuiya,
                icon: Icons.groups_outlined,
                color: DkmzvBrand.gold,
                onTap: () => _open(context, const AdminJumuiyas()),
              ),
              StatTile(
                value: '${store.data.homePins.length}',
                label: s.homePins,
                icon: Icons.home_outlined,
                color: DkmzvBrand.green,
                onTap: () => _open(context, const AdminHomePins()),
              ),
              StatTile(
                value: '${store.data.announcements.length}',
                label: s.announcements,
                icon: Icons.campaign_outlined,
                onTap: () => _open(context, const AdminAnnouncements()),
              ),
              StatTile(
                value: '${store.data.sermons.length}',
                label: s.sermons,
                icon: Icons.play_circle_outline,
                onTap: () => _open(context, const AdminSermons()),
              ),
              StatTile(
                value: '$unread',
                label: s.inbox,
                icon: Icons.mark_email_unread_outlined,
                color: unread > 0 ? DkmzvBrand.red : null,
                onTap: () => _open(context, const AdminInbox()),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _GoLiveCard(),
          SectionLabel(s.contentSection.toUpperCase()),
          _nav(context, Icons.campaign_outlined, s.announcements,
              store.data.announcements.length, () => const AdminAnnouncements()),
          _nav(context, Icons.menu_book_outlined, s.tabIbada,
              store.data.services.length, () => const AdminServices()),
          _nav(context, Icons.calendar_month_outlined, s.tabEvents,
              store.data.events.length, () => const AdminEvents()),
          _nav(context, Icons.play_circle_outline, s.sermons,
              store.data.sermons.length, () => const AdminSermons()),
          _nav(context, Icons.music_note_outlined, s.tabHymns,
              store.data.hymns.length, () => const AdminHymns()),
          _nav(context, Icons.schedule_outlined, s.sundayAdmin,
              store.data.sundayTimes.length, () => const AdminSundays()),
          SectionLabel(s.peopleSection.toUpperCase()),
          _nav(context, Icons.people_outline, s.registeredMembers,
              store.data.members.length, () => const AdminMembers()),
          _nav(context, Icons.account_balance_outlined, s.congregations,
              store.data.congregations.length, () => const AdminCongregations()),
          _nav(context, Icons.groups_outlined, s.jumuiya,
              store.data.jumuiyas.length, () => const AdminJumuiyas()),
          _nav(context, Icons.home_outlined, s.homePins,
              store.data.homePins.length, () => const AdminHomePins()),
          _nav(context, Icons.contact_phone_outlined, s.contactsAdmin,
              store.data.contacts.length, () => const AdminContacts()),
          _nav(context, Icons.mark_email_unread_outlined, s.inbox, unread,
              () => const AdminInbox(), highlight: unread > 0),
          SectionLabel(s.moneySection.toUpperCase()),
          _nav(context, Icons.volunteer_activism_outlined, s.givingGroups,
              store.data.giving.categories.length,
              () => const AdminGivingCategories()),
          _nav(context, Icons.credit_card, s.payByCard,
              store.data.giving.payments.stripeEnabled ? 1 : 0,
              () => const AdminPayments()),
          _nav(context, Icons.phone_android, s.givingAdmin, 1,
              () => const AdminGiving()),
          SectionLabel(s.settingsSection.toUpperCase()),
          _nav(context, Icons.church_outlined, s.churchAdmin, 1,
              () => const AdminChurch()),
          Card(
            child: ListTile(
              leading: Icon(Icons.password, color: accentOf(context)),
              title: Text(s.changePin),
              onTap: () => _changePin(context, store, s),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.restore, color: DkmzvBrand.red),
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
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget page) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => page),
      );

  Widget _nav(BuildContext context, IconData icon, String title, int count,
      Widget Function() page,
      {bool highlight = false}) {
    final surfaces = Surfaces.of(context);
    final accent = accentOf(context);
    return Card(
      child: ListTile(
        leading: Icon(icon, color: highlight ? DkmzvBrand.red : accent),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$count',
                style: TextStyle(
                    color: highlight ? DkmzvBrand.red : surfaces.muted,
                    fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: surfaces.muted, size: 20),
          ],
        ),
        onTap: () => _open(context, page()),
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

/// One switch the pastor's phone can hit when the YouTube stream starts.
class _GoLiveCard extends StatelessWidget {
  const _GoLiveCard();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final sermons = [...store.data.sermons]
      ..sort((a, b) => b.date.compareTo(a.date));
    final target = store.liveSermon ?? (sermons.isEmpty ? null : sermons.first);
    if (target == null) return const SizedBox.shrink();
    final playable = youtubeVideoId(target.mediaUrl) != null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: target.isLive
                ? DkmzvBrand.red.withValues(alpha: 0.5)
                : surfaces.hairline),
        color: target.isLive
            ? DkmzvBrand.red.withValues(alpha: 0.07)
            : surfaces.card,
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.adminToday.toUpperCase(),
                        style: TextStyle(
                            color: surfaces.muted,
                            fontSize: 11,
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(target.title(store.sw),
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              Switch(
                value: target.isLive,
                onChanged: (v) => store.setLiveSermon(target.id, v),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(s.goLiveHint,
              style: TextStyle(color: surfaces.muted, fontSize: 12.5)),
          const SizedBox(height: 10),
          Row(
            children: [
              if (target.isLive) ...[
                Pill(s.liveNow, color: DkmzvBrand.red, filled: true),
                const SizedBox(width: 8),
              ],
              if (!playable) Pill(s.openMedia, color: DkmzvBrand.gold),
              const Spacer(),
              if (target.mediaUrl.isNotEmpty)
                TextButton.icon(
                  onPressed: () => shareText(
                    '${target.title(store.sw)}\n${target.mediaUrl}',
                    subject: target.title(store.sw),
                  ),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: Text(s.shareLink),
                ),
            ],
          ),
        ],
      ),
    );
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
