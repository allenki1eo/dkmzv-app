import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../l10n/strings.dart';
import '../services/links.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

class GivingScreen extends StatelessWidget {
  const GivingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final g = store.data.giving;
    final totals = store.givingTotalsByGroup;

    return Scaffold(
      appBar: AppBar(title: Text(s.giving)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Text(s.givingLead, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          for (final group in GivingGroups.ordered)
            if (g.inGroup(group).isNotEmpty)
              _GroupBlock(group: group, categories: g.inGroup(group)),
          SectionLabel(s.payByMpesa.toUpperCase()),
          _MpesaCard(giving: g),
          if (store.data.givingNotes.isNotEmpty) ...[
            SectionLabel(s.myGiving.toUpperCase()),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in totals.entries)
                  Pill('${_groupName(s, entry.key)} · TZS ${formatMoney(entry.value)}'),
              ],
            ),
            const SizedBox(height: 12),
            for (final n in store.data.givingNotes.take(12))
              Dismissible(
                key: ValueKey(n.id),
                direction: DismissDirection.endToStart,
                background: const ColoredBox(color: Colors.transparent),
                onDismissed: (_) => store.deleteGivingNote(n.id),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(_methodIcon(n.method), color: surfaces.muted),
                  title: Text('TZS ${formatMoney(n.amount)}'),
                  subtitle: Text([
                    g.categoryById(n.categoryId)?.label(store.sw) ?? n.purposeId,
                    formatDateTime(n.at, store.localeCode),
                    if (n.note.isNotEmpty) n.note,
                  ].join(' · ')),
                ),
              ),
            const SizedBox(height: 8),
            FootNote(s.givingPrivate, icon: Icons.lock_outline),
          ],
          const SizedBox(height: 8),
          FootNote(s.exemptNote, icon: Icons.mail_outline),
          FootNote(s.separateNote, icon: Icons.calculate_outlined),
        ],
      ),
    );
  }
}

IconData _methodIcon(String method) {
  switch (method) {
    case 'stripe':
      return Icons.credit_card;
    case 'bahasha':
      return Icons.mail_outline;
    case 'taslimu':
      return Icons.payments_outlined;
    default:
      return Icons.phone_android;
  }
}

String _groupName(S s, String group) {
  switch (group) {
    case GivingGroups.bahasha:
      return s.groupBahasha;
    case GivingGroups.fungu:
      return s.groupFungu;
    case GivingGroups.shukrani:
      return s.groupShukrani;
    default:
      return s.groupSadaka;
  }
}

class _GroupBlock extends StatelessWidget {
  const _GroupBlock({required this.group, required this.categories});
  final String group;
  final List<GivingCategory> categories;

  @override
  Widget build(BuildContext context) {
    final s = sOf(context);
    final store = context.watch<ChurchStore>();
    final surfaces = Surfaces.of(context);
    final exempt = categories.every((c) => c.exempt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
          child: Row(
            children: [
              Text(
                _groupName(s, group).toUpperCase(),
                style: TextStyle(
                  color: surfaces.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(width: 8),
              if (exempt)
                Pill(s.exempt,
                    color: DkmzvBrand.sage, icon: Icons.verified_outlined),
            ],
          ),
        ),
        for (final c in categories)
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => showGiveSheet(context, c),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.label(store.sw),
                              style:
                                  Theme.of(context).textTheme.titleSmall),
                          if (c.note(store.sw).isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(c.note(store.sw),
                                style: TextStyle(
                                    color: surfaces.muted,
                                    fontSize: 12.5,
                                    height: 1.35)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: surfaces.muted, size: 20),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Future<void> showGiveSheet(BuildContext context, GivingCategory category) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _GiveSheet(category: category),
    ),
  );
}

class _GiveSheet extends StatefulWidget {
  const _GiveSheet({required this.category});
  final GivingCategory category;

  @override
  State<_GiveSheet> createState() => _GiveSheetState();
}

class _GiveSheetState extends State<_GiveSheet> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  late String _method = widget.category.exempt ? 'bahasha' : 'mpesa';

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
    final surfaces = Surfaces.of(context);
    final c = widget.category;
    final payments = store.data.giving.payments;
    final stripeUrl =
        c.stripeUrl.isNotEmpty ? c.stripeUrl : payments.defaultStripeUrl;
    final cardReady = payments.stripeEnabled && stripeUrl.isNotEmpty;
    final amounts = c.amounts.isEmpty ? store.data.giving.tips : c.amounts;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(c.label(store.sw),
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
                if (c.exempt) Pill(s.exempt, color: DkmzvBrand.sage),
              ],
            ),
            if (c.note(store.sw).isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(c.note(store.sw),
                  style: TextStyle(color: surfaces.muted, height: 1.4)),
            ],
            const SizedBox(height: 16),
            Text(s.chooseAmount,
                style: TextStyle(color: surfaces.muted, fontSize: 12.5)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tip in amounts)
                  ActionChip(
                    label: Text(formatMoney(tip)),
                    onPressed: () =>
                        setState(() => _amount.text = tip.toString()),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '${s.amount} (TZS)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _note,
              decoration: InputDecoration(
                  labelText: '${s.note} (${s.optional})'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _method = 'mpesa');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(store.data.giving.lipaNote(store.sw))),
                      );
                    },
                    icon: const Icon(Icons.phone_android, size: 18),
                    label: Text(s.payByMpesa),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: cardReady
                        ? () {
                            setState(() => _method = 'stripe');
                            openExternal(context, stripeUrl, s);
                          }
                        : null,
                    icon: const Icon(Icons.credit_card, size: 18),
                    label: Text(s.payByCard),
                  ),
                ),
              ],
            ),
            if (!cardReady) ...[
              const SizedBox(height: 8),
              FootNote(
                  payments.stripeNote(store.sw).isEmpty
                      ? s.cardComingSoon
                      : payments.stripeNote(store.sw),
                  icon: Icons.credit_card_off_outlined),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  final amount = int.tryParse(_amount.text.trim()) ?? 0;
                  await store.addGivingNote(
                    amount: amount,
                    purposeId: c.id,
                    categoryId: c.id,
                    method: _method,
                    note: _note.text,
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(s.saved)));
                  }
                },
                icon: const Icon(Icons.check, size: 18),
                label: Text(s.iGave),
              ),
            ),
            const SizedBox(height: 8),
            FootNote(s.iGaveHint, icon: Icons.receipt_long_outlined),
          ],
        ),
      ),
    );
  }
}

class _MpesaCard extends StatelessWidget {
  const _MpesaCard({required this.giving});
  final GivingConfig giving;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final p = store.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [p.cloth, p.clothDeep],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(18, 16, 10, 16),
          child: Column(
            children: [
              _copyRow(context, s, s.paybill, giving.paybill, p.onCloth),
              _copyRow(context, s, s.account, giving.account, p.onCloth),
              _copyRow(context, s, s.accountName, giving.accountName, p.onCloth),
              _copyRow(context, s, s.till, giving.till, p.onCloth),
            ],
          ),
        ),
        const SizedBox(height: 10),
        FootNote(giving.lipaNote(store.sw), icon: Icons.info_outline),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(s.steps,
                style: Theme.of(context).textTheme.titleSmall),
            children: [
              for (var i = 0; i < giving.steps(store.sw).length; i++)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: accentOf(context).withValues(alpha: 0.14),
                    child: Text('${i + 1}',
                        style: TextStyle(
                            color: accentOf(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                  title: Text(giving.steps(store.sw)[i]),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _copyRow(
      BuildContext context, S s, String label, String value, Color onCloth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: onCloth.withValues(alpha: 0.72), fontSize: 12)),
                Text(value,
                    style: TextStyle(
                        color: onCloth,
                        fontWeight: FontWeight.w700,
                        fontSize: 17)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => copyText(context, value, s),
            icon: const Icon(Icons.copy, color: DkmzvBrand.gold, size: 20),
          ),
        ],
      ),
    );
  }
}
