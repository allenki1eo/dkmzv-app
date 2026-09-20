import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'events_screen.dart';
import 'home_screen.dart';
import 'hymns_screen.dart';
import 'ibada_screen.dart';
import 'more_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = sOf(context);
    final pages = [
      HomeScreen(
        onOpenIbada: () => setState(() => _index = 1),
        onOpenHymns: () => setState(() => _index = 2),
        onOpenEvents: () => setState(() => _index = 3),
      ),
      const IbadaScreen(),
      const HymnsScreen(),
      const EventsScreen(),
      const MoreScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.campaign_outlined),
              selectedIcon: const Icon(Icons.campaign),
              label: s.tabHome),
          NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book),
              label: s.tabIbada),
          NavigationDestination(
              icon: const Icon(Icons.music_note_outlined),
              selectedIcon: const Icon(Icons.music_note),
              label: s.tabHymns),
          NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month),
              label: s.tabEvents),
          NavigationDestination(
              icon: const Icon(Icons.more_horiz),
              selectedIcon: const Icon(Icons.more_horiz),
              label: s.tabMore),
        ],
      ),
    );
  }
}
