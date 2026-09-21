import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/common.dart';
import '../widgets/tab_bar.dart';
import 'giving_screen.dart';
import 'home_screen.dart';
import 'hymns_screen.dart';
import 'ibada_screen.dart';
import 'more_screen.dart';
import 'sermons_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _select(int i) {
    if (i == _index) return;
    HapticFeedback.selectionClick();
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final s = sOf(context);
    final pages = [
      HomeScreen(
        // Ibada is a place you go to read one order of service, not somewhere
        // you live, so it opens as a page rather than holding a tab.
        onOpenIbada: () =>
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const IbadaScreen())),
        onOpenSermons: () => _select(1),
      ),
      const SermonsScreen(embedded: true),
      const HymnsScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      // The bar floats over content, so pages paint the full height behind it.
      extendBody: true,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: GlassTabBar(
        selectedIndex: _index,
        onSelect: _select,
        // Giving is the thing a mwumini comes back to do, so it gets the one
        // raised button rather than a tab like any other.
        center: CenterAction(
          icon: Icons.volunteer_activism_rounded,
          tooltip: s.giveNow,
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const GivingScreen())),
        ),
        items: [
          TabItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: s.tabHome,
          ),
          TabItem(
            icon: Icons.play_circle_outline,
            activeIcon: Icons.play_circle_fill_rounded,
            label: s.sermons,
          ),
          TabItem(
            icon: Icons.music_note_outlined,
            activeIcon: Icons.music_note_rounded,
            label: s.tabHymns,
          ),
          TabItem(
            icon: Icons.grid_view_outlined,
            activeIcon: Icons.grid_view_rounded,
            label: s.tabMore,
          ),
        ],
      ),
    );
  }
}
