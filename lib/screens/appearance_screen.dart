import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/store.dart';
import '../theme/backgrounds.dart';
import '../theme/brand.dart';
import '../widgets/common.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final s = sOf(context);
    final surfaces = Surfaces.of(context);
    final mode = store.data.settings.themeMode;

    return Scaffold(
      appBar: AppBar(title: Text(s.appearance)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          Text(
            s.appearanceHint,
            style: TextStyle(color: surfaces.muted, height: 1.45),
          ),
          SectionLabel(s.themeMode),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'system',
                icon: const Icon(Icons.brightness_auto_outlined, size: 18),
                label: Text(s.themeSystem),
              ),
              ButtonSegment(
                value: 'light',
                icon: const Icon(Icons.light_mode_outlined, size: 18),
                label: Text(s.themeLight),
              ),
              ButtonSegment(
                value: 'dark',
                icon: const Icon(Icons.dark_mode_outlined, size: 18),
                label: Text(s.themeDark),
              ),
            ],
            selected: {mode},
            showSelectedIcon: false,
            onSelectionChanged: (set) => store.setThemeMode(set.first),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(s.darkModeSwitch),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (v) => store.setThemeMode(v ? 'dark' : 'light'),
          ),
          SectionLabel(s.background),
          Text(
            s.backgroundHint,
            style: TextStyle(color: surfaces.muted, fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
            children: [
              for (final bg in AppBackground.all)
                _BackgroundTile(
                  background: bg,
                  selected: store.backgroundId == bg.id,
                  onTap: () => store.setBackground(bg.id),
                ),
            ],
          ),
          SectionLabel(s.language),
          Card(
            child: ListTile(
              leading: Icon(Icons.translate, color: accentOf(context)),
              title: Text(s.language),
              subtitle: Text(store.sw ? s.swahili : s.english),
              trailing: TextButton(
                onPressed: store.toggleLocale,
                child: Text(store.sw ? 'EN' : 'SW'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FootNote(s.lockedToSeason, icon: Icons.palette_outlined),
        ],
      ),
    );
  }
}

class _BackgroundTile extends StatelessWidget {
  const _BackgroundTile({
    required this.background,
    required this.selected,
    required this.onTap,
  });

  final AppBackground background;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();
    final surfaces = Surfaces.of(context);
    final accent = accentOf(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? accent : surfaces.hairline,
                  width: selected ? 2 : 1,
                ),
                color: surfaces.card,
              ),
              clipBehavior: Clip.antiAlias,
              child: background.asset == null
                  ? Icon(
                      Icons.format_color_reset_outlined,
                      color: surfaces.muted,
                    )
                  : Image.asset(background.asset!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            background.label(store.sw),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? accent : surfaces.ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
