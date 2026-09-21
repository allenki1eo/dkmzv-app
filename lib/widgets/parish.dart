import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../l10n/strings.dart';
import '../theme/brand.dart';
import 'common.dart';

IconData motifIcon(String motif) {
  switch (motif) {
    case 'cathedral':
      return Icons.account_balance_outlined;
    case 'sunrise':
      return Icons.wb_twilight_outlined;
    case 'cross':
      return Icons.add_outlined;
    default:
      return Icons.church_outlined;
  }
}

Color congregationColor(Congregation c) =>
    parseHexColor(c.accentHex) ?? DkmzvBrand.purple;

/// Tap the parish name anywhere to move between Ebenezer, Angaza, Makedonia.
class ParishButton extends StatelessWidget {
  const ParishButton({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final current = store.selectedCongregation;
    if (current == null) return const SizedBox.shrink();
    final accent = accentOf(context);
    return IconButton(
      tooltip: current.name(store.sw),
      onPressed: () => showParishSwitcher(context),
      icon: Icon(motifIcon(current.motif), color: accent),
    );
  }
}

Future<void> showParishSwitcher(BuildContext context) async {
  final store = context.read<ChurchStore>();
  final s = S(store.localeCode);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final surfaces = Surfaces.of(sheetContext);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                child: Text(s.congregations,
                    style: Theme.of(sheetContext).textTheme.headlineSmall),
              ),
              for (final c in store.data.congregations)
                _ParishRow(
                  congregation: c,
                  selected: store.data.settings.selectedCongregationId == c.id,
                  onTap: () {
                    store.selectCongregation(c.id);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              const SizedBox(height: 10),
              Text(s.parishLookHint,
                  style: TextStyle(color: surfaces.muted, fontSize: 12.5)),
            ],
          ),
        ),
      );
    },
  );
}

class _ParishRow extends StatelessWidget {
  const _ParishRow({
    required this.congregation,
    required this.selected,
    required this.onTap,
  });

  final Congregation congregation;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final surfaces = Surfaces.of(context);
    final color = accentForBrightness(
        congregationColor(congregation), Theme.of(context).brightness);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? color.withValues(alpha: 0.1) : surfaces.card,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: selected ? color.withValues(alpha: 0.5) : surfaces.hairline),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(motifIcon(congregation.motif),
                        color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(congregation.name(store.sw),
                            style: TextStyle(
                                color: surfaces.ink,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                        Text(
                          congregation.tagline(store.sw).isEmpty
                              ? congregation.role(store.sw)
                              : congregation.tagline(store.sw),
                          style:
                              TextStyle(color: surfaces.muted, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                  if (selected) Icon(Icons.check_circle, color: color, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}