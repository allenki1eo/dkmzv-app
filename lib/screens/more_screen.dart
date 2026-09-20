import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../widgets/common.dart';
import 'admin/admin_gate.dart';
import 'church_year_screen.dart';
import 'contact_screen.dart';
import 'giving_screen.dart';
import 'pastoral_screen.dart';
import 'sermons_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    return Scaffold(
      appBar: BrandAppBar(title: s.moreTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const SeasonBanner(),
          const SizedBox(height: 8),
          _tile(context, Icons.church_outlined, s.churchYear,
              const ChurchYearScreen()),
          _tile(context, Icons.volunteer_activism, s.giving, const GivingScreen()),
          _tile(context, Icons.headphones, s.sermons, const SermonsScreen()),
          _tile(context, Icons.place_outlined, s.contact, const ContactScreen()),
          _tile(context, Icons.volunteer_activism_outlined, s.pastoral,
              const PastoralScreen()),
          const Divider(),
          ListTile(
            leading: Icon(Icons.translate, color: store.palette.cloth),
            title: Text(s.language),
            subtitle: Text(store.sw ? s.swahili : s.english),
            trailing: TextButton(
              onPressed: store.toggleLocale,
              child: Text(store.sw ? 'EN' : 'SW'),
            ),
          ),
          _tile(context, Icons.admin_panel_settings_outlined, s.admin,
              const AdminGate()),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, Widget page) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: context.read<ChurchStore>().palette.cloth),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}
