import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../l10n/strings.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import 'jumuiya_map_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _note;
  late final TextEditingController _kaya;
  late final TextEditingController _birthYear;
  String? _congregationId;
  String? _jumuiyaId;
  late String _gender;
  late String _status;
  late bool _baptized;
  late bool _confirmed;
  late bool _sharePin;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final store = context.read<ChurchStore>();
    final existing = store.currentMember;
    _name = TextEditingController(text: existing?.fullName ?? '');
    _phone = TextEditingController(text: existing?.phone ?? '');
    _note = TextEditingController(text: existing?.householdNote ?? '');
    _kaya = TextEditingController(text: existing?.kaya ?? '');
    _birthYear = TextEditingController(text: existing?.birthYear ?? '');
    _congregationId = existing?.congregationId.isNotEmpty == true
        ? existing!.congregationId
        : store.selectedCongregation?.id;
    _jumuiyaId = existing?.jumuiyaId;
    _gender = existing?.gender ?? '';
    _status = existing?.status ?? 'mwanachama';
    _baptized = existing?.baptized ?? false;
    _confirmed = existing?.confirmed ?? false;
    _sharePin = existing?.shareHomePin ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _note.dispose();
    _kaya.dispose();
    _birthYear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final congregations = store.data.congregations;
    final jumuiyas = _congregationId == null
        ? const <Jumuiya>[]
        : store.jumuiyasFor(_congregationId!);
    if (_jumuiyaId != null && jumuiyas.every((j) => j.id != _jumuiyaId)) {
      _jumuiyaId = jumuiyas.isEmpty ? null : jumuiyas.first.id;
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.registerTitle)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
          children: [
            Text(
              s.registerLead,
              style: TextStyle(color: surfaces.muted, height: 1.45),
            ),
            if (store.currentMember != null) ...[
              const SizedBox(height: 12),
              Pill(
                s.alreadyRegistered,
                color: DkmzvBrand.clothGreen,
                icon: Icons.verified_user_outlined,
              ),
            ],
            SectionLabel(s.fullName),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: s.fullName),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? s.required : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _kaya,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: s.kaya,
                helperText: s.kayaHint,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in [
                  ('mwanachama', s.statusMwanachama),
                  ('kijana', s.statusKijana),
                  ('mtoto', s.statusMtoto),
                  ('mgeni', s.statusMgeni),
                ])
                  ChoiceChip(
                    label: Text(option.$2),
                    selected: _status == option.$1,
                    onSelected: (_) => setState(() => _status = option.$1),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(s.male),
                  selected: _gender == 'me',
                  onSelected: (v) => setState(() => _gender = v ? 'me' : ''),
                ),
                ChoiceChip(
                  label: Text(s.female),
                  selected: _gender == 'ke',
                  onSelected: (v) => setState(() => _gender = v ? 'ke' : ''),
                ),
              ],
            ),
            SectionLabel(s.jumuiya),
            DropdownButtonFormField<String>(
              key: ValueKey('cong-$_congregationId'),
              initialValue: congregations.any((c) => c.id == _congregationId)
                  ? _congregationId
                  : null,
              decoration: InputDecoration(labelText: s.congregations),
              items: [
                for (final c in congregations)
                  DropdownMenuItem(value: c.id, child: Text(c.name(store.sw))),
              ],
              onChanged: (v) => setState(() {
                _congregationId = v;
                _jumuiyaId = null;
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey('jum-$_jumuiyaId'),
              initialValue: jumuiyas.any((j) => j.id == _jumuiyaId)
                  ? _jumuiyaId
                  : null,
              decoration: InputDecoration(labelText: s.jumuiya),
              items: [
                for (final j in jumuiyas)
                  DropdownMenuItem(value: j.id, child: Text(j.name(store.sw))),
              ],
              onChanged: jumuiyas.isEmpty
                  ? null
                  : (v) => setState(() => _jumuiyaId = v),
            ),
            SectionLabel(s.details),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: s.phoneOfficeOnly),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _birthYear,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: '${s.birthYear} (${s.optional})',
                counterText: '',
              ),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _note,
              maxLines: 2,
              decoration: InputDecoration(labelText: s.household),
            ),
            const SizedBox(height: 6),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(s.baptized),
              value: _baptized,
              onChanged: (v) => setState(() => _baptized = v ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(s.confirmed),
              value: _confirmed,
              onChanged: (v) => setState(() => _confirmed = v ?? false),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.shareMyHome),
              subtitle: Text(
                s.homePinsNote,
                style: TextStyle(color: surfaces.muted, fontSize: 12.5),
              ),
              value: _sharePin,
              onChanged: (v) => setState(() => _sharePin = v),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => _submit(store, s),
              child: Text(s.save),
            ),
            if (_saved) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: DkmzvBrand.clothGreen,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s.registeredOk,
                      style: const TextStyle(color: DkmzvBrand.clothGreen),
                    ),
                  ),
                ],
              ),
            ],
            if (_sharePin && _jumuiyaId != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => JumuiyaMapScreen(
                      congregationId: _congregationId,
                      jumuiyaId: _jumuiyaId,
                    ),
                  ),
                ),
                icon: const Icon(Icons.map_outlined),
                label: Text(s.jumuiyaMap),
              ),
            ],
            const SizedBox(height: 10),
            FootNote(s.privacyLead, icon: Icons.lock_outline),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(ChurchStore store, S s) async {
    if (!_form.currentState!.validate()) return;
    if (_congregationId == null) return;
    final existing = store.currentMember;
    await store.saveMember(
      MemberRecord(
        id: existing?.id ?? const Uuid().v4(),
        fullName: _name.text.trim(),
        congregationId: _congregationId!,
        jumuiyaId: _jumuiyaId ?? '',
        phone: _phone.text.trim(),
        householdNote: _note.text.trim(),
        shareHomePin: _sharePin,
        homeLat: existing?.homeLat,
        homeLng: existing?.homeLng,
        registeredAt:
            existing?.registeredAt ?? DateTime.now().toIso8601String(),
        kaya: _kaya.text.trim(),
        gender: _gender,
        status: _status,
        baptized: _baptized,
        confirmed: _confirmed,
        birthYear: _birthYear.text.trim(),
      ),
    );
    await store.selectCongregation(_congregationId!);
    if (mounted) setState(() => _saved = true);
  }
}
