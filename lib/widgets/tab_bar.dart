import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/brand.dart';
import '../theme/tokens.dart';
import 'common.dart';

/// One destination in [GlassTabBar].
class TabItem {
  const TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// The shell's bottom bar: a frosted slab that floats clear of the screen
/// edge instead of sitting flush against it.
///
/// It blurs whatever scrolls under it, so a chosen wallpaper still reads
/// through, and the selected destination is marked by a soft plate that
/// slides between tabs rather than appearing under the new one.
class GlassTabBar extends StatelessWidget {
  const GlassTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<TabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  /// Height of the bar itself, without the safe-area inset beneath it.
  static const double barHeight = 60;

  /// What a scroll view should leave at its bottom so the last row can clear
  /// the floating bar.
  static const double scrollInset = 92;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final accent = accentOf(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Insets.md,
        0,
        Insets.md,
        bottomSafe > 0 ? bottomSafe * 0.5 + Insets.sm : Insets.md,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.xl),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: s.card.withValues(alpha: dark ? 0.76 : 0.85),
              borderRadius: BorderRadius.circular(Radii.xl),
              border: Border.all(color: s.hairline),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final slot = constraints.maxWidth / items.length;
                const plate = 50.0;
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      left: slot * selectedIndex + (slot - plate) / 2,
                      top: 6,
                      width: plate,
                      height: barHeight - 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: dark ? 0.20 : 0.10),
                          borderRadius: BorderRadius.circular(Radii.md),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < items.length; i++)
                          Expanded(
                            child: _Tab(
                              item: items[i],
                              selected: i == selectedIndex,
                              onTap: () => onSelect(i),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatefulWidget {
  const _Tab({required this.item, required this.selected, required this.onTap});

  final TabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v && mounted) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final accent = accentOf(context);
    final tint = widget.selected ? accent : s.muted;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapCancel: () => _set(false),
        onTapUp: (_) => _set(false),
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _down ? 0.9 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: SizedBox(
            height: GlassTabBar.barHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.selected ? widget.item.activeIcon : widget.item.icon,
                  size: 22,
                  color: tint,
                ),
                const SizedBox(height: 3),
                Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: DkmzvBrand.sans,
                    fontSize: 10.5,
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: widget.selected ? s.ink : s.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
