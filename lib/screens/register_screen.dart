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
  String? _congregationId;
  String? _jumuiyaId;
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
    _congregationId = existing?.congregationId.isNotEmpty == true
        ? existing!.congregationId
        : store.selectedCongregation?.id;
    _jumuiyaId = existing?.jumuiyaId;
    _sharePin = existing?.shareHomePin ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final congregations = store.data.congregations;
    final jumuiyas = _congregationId == null
        ? const <Jumuiya>[]
        : store.jumuiyasFor(_congregationId!);
    if (_jumuiyaId != null &&
        jumuiyas.every((j) => j.id != _jumuiyaId)) {
      _jumuiyaId = jumuiyas.isEmpty ? null : jumuiyas.first.id;
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.register)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Text(s.registerLead,
                style: const TextStyle(color: DkmzvBrand.muted, height: 1.4)),
            if (store.currentMember != null) ...[
              const SizedBox(height: 8),
              Text(s.alreadyRegistered,
                  style: const TextStyle(
                      color: DkmzvBrand.green, fontWeight: FontWeight.w700)),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: s.fullName),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? s.required : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey('cong-$_congregationId'),
              initialValue: congregations.any((c) => c.id == _congregationId)
                  ? _congregationId
                  : null,
              decoration: InputDecoration(labelText: s.congregations),
              items: [
                for (final c in congregations)
                  DropdownMenuItem(
                    value: c.id,
                    child: Text(c.name(store.sw)),
                  ),
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
                  DropdownMenuItem(
                    value: j.id,
                    child: Text(j.name(store.sw)),
                  ),
              ],
              onChanged: jumuiyas.isEmpty
                  ? null
                  : (v) => setState(() => _jumuiyaId = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: s.phoneOfficeOnly),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _note,
              maxLines: 2,
              decoration: InputDecoration(labelText: s.household),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.shareMyHome),
              value: _sharePin,
              onChanged: (v) => setState(() => _sharePin = v),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _submit(store, s),
              child: Text(s.save),
            ),
            if (_saved) ...[
              const SizedBox(height: 12),
              Text(s.registeredOk,
                  style: const TextStyle(color: DkmzvBrand.green)),
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
          ],
        ),
      ),
    );
  }

  Future<void> _submit(ChurchStore store, S s) async {
    if (!_form.currentState!.validate()) return;
    if (_congregationId == null) return;
    final existing = store.currentMember;
    await store.saveMember(MemberRecord(
      id: existing?.id ?? const Uuid().v4(),
      fullName: _name.text.trim(),
      congregationId: _congregationId!,
      jumuiyaId: _jumuiyaId ?? '',
      phone: _phone.text.trim(),
      householdNote: _note.text.trim(),
      shareHomePin: _sharePin,
      homeLat: existing?.homeLat,
      homeLng: existing?.homeLng,
      registeredAt: existing?.registeredAt ?? DateTime.now().toIso8601String(),
    ));
    if (_congregationId != null) {
      await store.selectCongregation(_congregationId!);
    }
    if (mounted) setState(() => _saved = true);
  }
}
