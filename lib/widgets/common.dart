import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../l10n/strings.dart';
import '../theme/brand.dart';

S sOf(BuildContext context) {
  final code = context.watch<ChurchStore>().localeCode;
  return S(code);
}

class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          ClipOval(
            child: Image.asset(
              DkmzvBrand.playstoreAsset,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      actions: [
        const LocaleToggle(),
        ...?actions,
      ],
    );
  }
}

class LocaleToggle extends StatelessWidget {
  const LocaleToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final sw = store.sw;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: store.toggleLocale,
        style: TextButton.styleFrom(foregroundColor: Colors.white),
        child: Text(sw ? 'EN' : 'SW',
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: DkmzvBrand.purple,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}

String formatDate(String iso, String locale) {
  final dt = DateTime.tryParse(iso);
  if (dt == null) return iso;
  final loc = locale == 'en' ? 'en' : 'sw';
  return DateFormat.yMMMEd(loc).format(dt);
}

String formatDateTime(String iso, String locale) {
  final dt = DateTime.tryParse(iso);
  if (dt == null) return iso;
  final loc = locale == 'en' ? 'en' : 'sw';
  return DateFormat.yMMMd(loc).add_Hm().format(dt);
}

Color liturgical(String name) {
  switch (name) {
    case 'purple':
      return DkmzvBrand.purple;
    case 'gold':
      return DkmzvBrand.gold;
    case 'white':
      return const Color(0xFFF4EFE3);
    case 'red':
      return const Color(0xFF9B1D2E);
    default:
      return DkmzvBrand.green;
  }
}
