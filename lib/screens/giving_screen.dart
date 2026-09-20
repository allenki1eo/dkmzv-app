import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

class GivingScreen extends StatefulWidget {
  const GivingScreen({super.key});

  @override
  State<GivingScreen> createState() => _GivingScreenState();
}

class _GivingScreenState extends State<GivingScreen> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String? _purpose;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final g = store.data.giving;
    _purpose ??= g.purposes.isNotEmpty ? g.purposes.first.id : 'tithe';

    return Scaffold(
      appBar: AppBar(title: Text(s.giving)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Text(s.givingLead),
          const SizedBox(height: 12),
          Card(
            color: store.palette.cloth,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _copyRow(context, s, s.paybill, g.paybill),
                  _copyRow(context, s, s.account, g.account),
                  _copyRow(context, s, s.accountName, g.accountName),
                  _copyRow(context, s, s.till, g.till),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(g.lipaNote(store.sw),
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 12)),
          SectionLabel(s.steps),
          for (var i = 0; i < g.steps(store.sw).length; i++)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: DkmzvBrand.green,
                child: Text('${i + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              title: Text(g.steps(store.sw)[i]),
            ),
          SectionLabel(s.amountTips),
          Wrap(
            spacing: 8,
            children: [
              for (final tip in g.tips)
                ActionChip(
                  label: Text('$tip'),
                  onPressed: () =>
                      setState(() => _amount.text = tip.toString()),
                ),
            ],
          ),
          SectionLabel(s.iGave),
          Text(s.iGaveHint,
              style: const TextStyle(color: DkmzvBrand.muted, fontSize: 12)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _purpose,
            items: [
              for (final p in g.purposes)
                DropdownMenuItem(
                    value: p.id, child: Text(p.label(store.sw))),
            ],
            onChanged: (v) => setState(() => _purpose = v),
            decoration: InputDecoration(labelText: s.purpose),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: s.amount),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _note,
            decoration: InputDecoration(labelText: s.note),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              final amt = int.tryParse(_amount.text.trim()) ?? 0;
              await store.addGivingNote(
                amount: amt,
                purposeId: _purpose ?? 'tithe',
                note: _note.text,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(s.saved)));
                _amount.clear();
                _note.clear();
              }
            },
            child: Text(s.saveNote),
          ),
          if (store.data.givingNotes.isNotEmpty) ...[
            SectionLabel(s.myNotes),
            for (final n in store.data.givingNotes)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('TZS ${n.amount}'),
                subtitle: Text(
                    '${formatDateTime(n.at, store.localeCode)}\n${n.note}'),
                isThreeLine: n.note.isNotEmpty,
              ),
          ],
        ],
      ),
    );
  }

  Widget _copyRow(BuildContext context, dynamic s, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12)),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => copyText(context, value, s),
            icon: const Icon(Icons.copy, color: DkmzvBrand.gold),
          ),
        ],
      ),
    );
  }
}
