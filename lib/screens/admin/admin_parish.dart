import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/models.dart';
import '../../data/store.dart';
import '../../theme/brand.dart';
import '../../widgets/common.dart';
import '../../widgets/parish.dart';

const _uuid = Uuid();

/// Each usharika keeps its own name, pin, colour and motif.
class AdminCongregations extends StatelessWidget {
  const AdminCongregations({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.congregations)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        children: [
          for (final c in store.data.congregations)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      congregationColor(c).withValues(alpha: 0.16),
                  child: Icon(motifIcon(c.motif),
                      color: congregationColor(c), size: 20),
                ),
                title: Text(c.name(store.sw)),
                subtitle: Text([
                  c.role(store.sw),
                  '${c.latitude.toStringAsFixed(5)}, ${c.longitude.toStringAsFixed(5)}',
                  '${store.jumuiyasFor(c.id).length} ${s.jumuiya}',
                ].join(' · ')),
                isThreeLine: true,
                onTap: () => _edit(context, c),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () =>
                      _confirm(context, () => store.deleteCongregation(c.id)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, Congregation? existing) async {
    final store = context.read<ChurchStore>();
    final s = sOf(context);
    final item = existing ??
        Congregation(
          id: _uuid.v4(),
          nameSw: '',
          nameEn: '',
          roleSw: 'Usharika mwenza',
          roleEn: 'Sister congregation',
          isMain: false,
          approximate: true,
          addressSw: '',
          addressEn: '',
          latitude: -3.669681,
          longitude: 33.427495,
          noteSw: '',
          noteEn: '',
        );
    final nameSw = TextEditingController(text: item.nameSw);
    final nameEn = TextEditingController(text: item.nameEn);
    final roleSw = TextEditingController(text: item.roleSw);
    final roleEn = TextEditingController(text: item.roleEn);
    final tagSw = TextEditingController(text: item.taglineSw);
    final tagEn = TextEditingController(text: item.taglineEn);
    final addrSw = TextEditingController(text: item.addressSw);
    final addrEn = TextEditingController(text: item.addressEn);
    final lat = TextEditingController(text: '${item.latitude}');
    final lng = TextEditingController(text: '${item.longitude}');
    final accent = ValueNotifier(item.accentHex);
    final motif = ValueNotifier(item.motif);
    final isMain = ValueNotifier(item.isMain);

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? s.add : s.edit),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameSw,
                    decoration: InputDecoration(labelText: s.titleSw)),
                TextField(
                    controller: nameEn,
                    decoration: InputDecoration(labelText: s.titleEn)),
                TextField(
                    controller: roleSw,
                    decoration:
                        const InputDecoration(labelText: 'Role SW')),
                TextField(
                    controller: roleEn,
                    decoration:
                        const InputDecoration(labelText: 'Role EN')),
                TextField(
                    controller: tagSw,
                    decoration:
                        const InputDecoration(labelText: 'Tagline SW')),
                TextField(
                    controller: tagEn,
                    decoration:
                        const InputDecoration(labelText: 'Tagline EN')),
                TextField(
                    controller: addrSw,
                    decoration:
                        InputDecoration(labelText: '${s.address} SW')),
                TextField(
                    controller: addrEn,
                    decoration:
                        InputDecoration(labelText: '${s.address} EN')),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: lat,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Lat')),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                          controller: lng,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Lng')),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: accent,
                  builder: (_, value, _) => Wrap(
                    spacing: 8,
                    children: [
                      for (final hex in const [
                        '#0F5F52',
                        '#1B4F7A',
                        '#8A5A12',
                        '#3F6B2B',
                        '#8B1E2D',
                        '#4A6572',
                      ])
                        GestureDetector(
                          onTap: () => accent.value = hex,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: parseHexColor(hex),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: value == hex
                                    ? Surfaces.of(context).ink
                                    : Surfaces.of(context).hairline,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: motif,
                  builder: (_, value, _) => Wrap(
                    spacing: 8,
                    children: [
                      for (final m in const [
                        'cathedral',
                        'sunrise',
                        'cross',
                        'church'
                      ])
                        ChoiceChip(
                          avatar: Icon(motifIcon(m), size: 16),
                          label: Text(m),
                          selected: value == m,
                          onSelected: (_) => motif.value = m,
                        ),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: isMain,
                  builder: (_, value, _) => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Kanisa kuu'),
                    value: value,
                    onChanged: (v) => isMain.value = v,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(s.save)),
        ],
      ),
    );

    if (ok == true) {
      await store.upsertCongregation(Congregation(
        id: item.id,
        nameSw: nameSw.text.trim(),
        nameEn: nameEn.text.trim(),
        roleSw: roleSw.text.trim(),
        roleEn: roleEn.text.trim(),
        isMain: isMain.value,
        approximate: item.approximate,
        addressSw: addrSw.text.trim(),
        addressEn: addrEn.text.trim(),
        latitude: double.tryParse(lat.text.trim()) ?? item.latitude,
        longitude: double.tryParse(lng.text.trim()) ?? item.longitude,
        noteSw: item.noteSw,
        noteEn: item.noteEn,
        accentHex: accent.value,
        motif: motif.value,
        taglineSw: tagSw.text.trim(),
        taglineEn: tagEn.text.trim(),
      ));
    }
  }
}

/// Jumuiya list with the geofence radius the map draws.
class AdminJumuiyas extends StatelessWidget {
  const AdminJumuiyas({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.jumuiya)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        children: [
          for (final c in store.data.congregations) ...[
            SectionLabel(c.name(store.sw)),
            for (final j in store.jumuiyasFor(c.id))
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        (parseHexColor(j.colorHex) ?? congregationColor(c))
                            .withValues(alpha: 0.16),
                    child: Icon(Icons.groups_outlined,
                        size: 20,
                        color:
                            parseHexColor(j.colorHex) ?? congregationColor(c)),
                  ),
                  title: Text(j.name(store.sw)),
                  subtitle: Text([
                    '${s.radius}: ${j.radiusMeters.round()} m',
                    '${s.homesInside}: ${store.pinsInsideGeofence(j).length}',
                  ].join(' · ')),
                  onTap: () => _edit(context, j),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        _confirm(context, () => store.deleteJumuiya(j.id)),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context, Jumuiya? existing) async {
    final store = context.read<ChurchStore>();
    final s = sOf(context);
    final congregations = store.data.congregations;
    final item = existing ??
        Jumuiya(
          id: _uuid.v4(),
          congregationId: store.selectedCongregation?.id ??
              (congregations.isEmpty ? '' : congregations.first.id),
          nameSw: '',
          nameEn: '',
          meetingNoteSw: '',
          meetingNoteEn: '',
          latitude: store.selectedCongregation?.latitude ?? -3.669681,
          longitude: store.selectedCongregation?.longitude ?? 33.427495,
        );
    final nameSw = TextEditingController(text: item.nameSw);
    final nameEn = TextEditingController(text: item.nameEn);
    final noteSw = TextEditingController(text: item.meetingNoteSw);
    final noteEn = TextEditingController(text: item.meetingNoteEn);
    final lat = TextEditingController(text: '${item.latitude}');
    final lng = TextEditingController(text: '${item.longitude}');
    final radius = ValueNotifier(item.radiusMeters.clamp(100, 2000).toDouble());
    final congId = ValueNotifier(item.congregationId);

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? s.add : s.edit),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: congId,
                  builder: (_, value, _) => DropdownButtonFormField<String>(
                    initialValue:
                        congregations.any((c) => c.id == value) ? value : null,
                    decoration: InputDecoration(labelText: s.congregations),
                    items: [
                      for (final c in congregations)
                        DropdownMenuItem(
                            value: c.id, child: Text(c.name(store.sw))),
                    ],
                    onChanged: (v) => congId.value = v ?? value,
                  ),
                ),
                TextField(
                    controller: nameSw,
                    decoration: InputDecoration(labelText: s.titleSw)),
                TextField(
                    controller: nameEn,
                    decoration: InputDecoration(labelText: s.titleEn)),
                TextField(
                    controller: noteSw,
                    decoration: InputDecoration(labelText: '${s.note} SW')),
                TextField(
                    controller: noteEn,
                    decoration: InputDecoration(labelText: '${s.note} EN')),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: lat,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Lat')),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                          controller: lng,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Lng')),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: radius,
                  builder: (_, value, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${s.radius}: ${value.round()} m'),
                      Slider(
                        value: value,
                        min: 100,
                        max: 2000,
                        divisions: 38,
                        label: '${value.round()} m',
                        onChanged: (v) => radius.value = v,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(s.save)),
        ],
      ),
    );

    if (ok == true) {
      await store.upsertJumuiya(Jumuiya(
        id: item.id,
        congregationId: congId.value,
        nameSw: nameSw.text.trim(),
        nameEn: nameEn.text.trim(),
        meetingNoteSw: noteSw.text.trim(),
        meetingNoteEn: noteEn.text.trim(),
        latitude: double.tryParse(lat.text.trim()) ?? item.latitude,
        longitude: double.tryParse(lng.text.trim()) ?? item.longitude,
        radiusMeters: radius.value,
        colorHex: item.colorHex,
        leaderRole: item.leaderRole,
      ));
    }
  }
}

/// Bahasha / fungu la kumi / shukrani and their Stripe links.
class AdminGivingCategories extends StatelessWidget {
  const AdminGivingCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final g = store.data.giving;
    return Scaffold(
      appBar: AppBar(title: Text(s.givingGroups)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        children: [
          FootNote(s.exemptNote, icon: Icons.mail_outline),
          for (final group in GivingGroups.ordered) ...[
            if (g.inGroup(group).isNotEmpty)
              SectionLabel(_groupLabel(s, group)),
            for (final c in g.inGroup(group))
              Card(
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(c.label(store.sw))),
                      if (c.exempt)
                        Pill(s.exempt, color: DkmzvBrand.sage),
                    ],
                  ),
                  subtitle: Text([
                    if (c.note(store.sw).isNotEmpty) c.note(store.sw),
                    if (c.stripeUrl.isNotEmpty) s.stripeLink,
                  ].join(' · ')),
                  onTap: () => _edit(context, c),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirm(
                        context, () => store.deleteGivingCategory(c.id)),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _groupLabel(dynamic s, String group) {
    switch (group) {
      case GivingGroups.bahasha:
        return s.groupBahasha as String;
      case GivingGroups.fungu:
        return s.groupFungu as String;
      case GivingGroups.shukrani:
        return s.groupShukrani as String;
      default:
        return s.groupSadaka as String;
    }
  }

  Future<void> _edit(BuildContext context, GivingCategory? existing) async {
    final store = context.read<ChurchStore>();
    final s = sOf(context);
    final item = existing ??
        GivingCategory(
          id: _uuid.v4(),
          group: GivingGroups.bahasha,
          sw: '',
          en: '',
          exempt: true,
        );
    final sw = TextEditingController(text: item.sw);
    final en = TextEditingController(text: item.en);
    final noteSw = TextEditingController(text: item.noteSw);
    final noteEn = TextEditingController(text: item.noteEn);
    final stripe = TextEditingController(text: item.stripeUrl);
    final amounts = TextEditingController(text: item.amounts.join(','));
    final group = ValueNotifier(item.group);
    final exempt = ValueNotifier(item.exempt);

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? s.add : s.edit),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: group,
                  builder: (_, value, _) => DropdownButtonFormField<String>(
                    initialValue: value,
                    decoration: InputDecoration(labelText: s.givingGroups),
                    items: [
                      for (final gr in GivingGroups.ordered)
                        DropdownMenuItem(
                            value: gr, child: Text(_groupLabel(s, gr))),
                    ],
                    onChanged: (v) {
                      group.value = v ?? value;
                      exempt.value = group.value == GivingGroups.bahasha;
                    },
                  ),
                ),
                TextField(
                    controller: sw,
                    decoration: InputDecoration(labelText: s.titleSw)),
                TextField(
                    controller: en,
                    decoration: InputDecoration(labelText: s.titleEn)),
                TextField(
                    controller: noteSw,
                    decoration: InputDecoration(labelText: '${s.note} SW')),
                TextField(
                    controller: noteEn,
                    decoration: InputDecoration(labelText: '${s.note} EN')),
                TextField(
                    controller: amounts,
                    decoration: InputDecoration(labelText: s.amountTips)),
                TextField(
                    controller: stripe,
                    decoration: InputDecoration(labelText: s.stripeLink)),
                ValueListenableBuilder(
                  valueListenable: exempt,
                  builder: (_, value, _) => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.exempt),
                    subtitle: Text(s.exemptNote,
                        style: const TextStyle(fontSize: 12)),
                    value: value,
                    onChanged: (v) => exempt.value = v,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(s.save)),
        ],
      ),
    );

    if (ok == true) {
      await store.upsertGivingCategory(GivingCategory(
        id: item.id,
        group: group.value,
        sw: sw.text.trim(),
        en: en.text.trim(),
        exempt: exempt.value,
        stripeUrl: stripe.text.trim(),
        noteSw: noteSw.text.trim(),
        noteEn: noteEn.text.trim(),
        amounts: amounts.text
            .split(',')
            .map((e) => int.tryParse(e.trim()) ?? 0)
            .where((e) => e > 0)
            .toList(),
      ));
    }
  }
}

/// Stripe Payment Links — no secret keys live in the app.
class AdminPayments extends StatefulWidget {
  const AdminPayments({super.key});

  @override
  State<AdminPayments> createState() => _AdminPaymentsState();
}

class _AdminPaymentsState extends State<AdminPayments> {
  late final TextEditingController _account;
  late final TextEditingController _url;
  late final TextEditingController _noteSw;
  late final TextEditingController _noteEn;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    final p = context.read<ChurchStore>().data.giving.payments;
    _account = TextEditingController(text: p.stripeAccountName);
    _url = TextEditingController(text: p.defaultStripeUrl);
    _noteSw = TextEditingController(text: p.stripeNoteSw);
    _noteEn = TextEditingController(text: p.stripeNoteEn);
    _enabled = p.stripeEnabled;
  }

  @override
  void dispose() {
    _account.dispose();
    _url.dispose();
    _noteSw.dispose();
    _noteEn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.moneySection)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(s.payByCard),
            subtitle: Text(s.cardComingSoon),
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
          ),
          const SizedBox(height: 8),
          TextField(
              controller: _account,
              decoration: InputDecoration(labelText: s.accountName)),
          const SizedBox(height: 10),
          TextField(
              controller: _url,
              decoration: InputDecoration(
                labelText: s.stripeLink,
                hintText: 'https://buy.stripe.com/...',
              )),
          const SizedBox(height: 10),
          TextField(
              controller: _noteSw,
              maxLines: 2,
              decoration: InputDecoration(labelText: '${s.note} SW')),
          const SizedBox(height: 10),
          TextField(
              controller: _noteEn,
              maxLines: 2,
              decoration: InputDecoration(labelText: '${s.note} EN')),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await store.savePayments(PaymentConfig(
                stripeEnabled: _enabled,
                stripeAccountName: _account.text.trim(),
                defaultStripeUrl: _url.text.trim(),
                stripeNoteSw: _noteSw.text.trim(),
                stripeNoteEn: _noteEn.text.trim(),
              ));
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(s.saved)));
              }
            },
            child: Text(s.save),
          ),
          const SizedBox(height: 12),
          FootNote(s.exemptNote, icon: Icons.mail_outline),
          FootNote(s.separateNote, icon: Icons.calculate_outlined),
        ],
      ),
    );
  }
}

Future<void> _confirm(BuildContext context, Future<void> Function() onYes) async {
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
