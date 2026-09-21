import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';
import '../widgets/parish.dart';
import 'admin/admin_gate.dart';
import 'appearance_screen.dart';
import 'church_year_screen.dart';
import 'congregations_screen.dart';
import 'contact_screen.dart';
import 'events_screen.dart';
import 'giving_screen.dart';
import 'jumuiya_map_screen.dart';
import 'pastoral_screen.dart';
import 'register_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final congregation = store.selectedCongregation;
    return Scaffold(
      appBar: BrandAppBar(
        title: s.moreTitle,
        subtitle: congregation?.name(store.sw),
        actions: const [ParishButton(), LocaleToggle()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          const SeasonBanner(),
          SectionLabel(s.contentSection),
          _tile(context, Icons.calendar_month_outlined, s.tabEvents,
              const EventsScreen()),
          _tile(context, Icons.volunteer_activism_outlined, s.giving,
              const GivingScreen()),
          _tile(context, Icons.church_outlined, s.churchYear,
              const ChurchYearScreen()),
          SectionLabel(s.peopleSection),
          _tile(context, Icons.account_balance_outlined, s.congregations,
              const CongregationsScreen()),
          _tile(context, Icons.map_outlined, s.jumuiyaMap,
              const JumuiyaMapScreen()),
          _tile(context, Icons.badge_outlined, s.registerTitle,
              const RegisterScreen()),
          _tile(context, Icons.handshake_outlined, s.pastoral,
              const PastoralScreen()),
          _tile(context, Icons.place_outlined, s.contact,
              const ContactScreen()),
          SectionLabel(s.settingsSection),
          _tile(context, Icons.palette_outlined, s.appearance,
              const AppearanceScreen()),
          _tile(context, Icons.admin_panel_settings_outlined, s.admin,
              const AdminGate()),
          const SizedBox(height: 12),
          FootNote(s.whatsappComplement, icon: Icons.chat_bubble_outline),
          FootNote(s.offlineNote, icon: Icons.offline_pin_outlined),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, Widget page) {
    final surfaces = Surfaces.of(context);
    return Card(
      child: ListTile(
        leading: Icon(icon, color: accentOf(context)),
        title: Text(label),
        trailing: Icon(Icons.chevron_right, color: surfaces.muted, size: 20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}
