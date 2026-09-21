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

/// The raised button that sits in the middle of the bar.
class CenterAction {
  const CenterAction({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
}

/// The shell's bottom bar: a frosted slab that floats clear of the screen
/// edge, with the one action a member reaches for raised in the middle of it.
///
/// It blurs whatever scrolls under it, so a chosen wallpaper still reads
/// through, and the selected destination is marked by a tinted plate that
/// slides between tabs rather than appearing under the new one.
class GlassTabBar extends StatelessWidget {
  const GlassTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    this.center,
  });

  final List<TabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  /// Optional raised button between the middle pair of destinations.
  final CenterAction? center;

  /// Height of the bar itself, without the safe-area inset beneath it.
  static const double barHeight = 62;

  /// Side of the raised centre button, which is a rounded square.
  static const double fabSize = 54;

  /// What a scroll view should leave at its bottom so the last row can clear
  /// the floating bar.
  static const double scrollInset = 116;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    final accent = accentOf(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final half = (items.length / 2).ceil();

    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(Radii.xl),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: barHeight,
          decoration: BoxDecoration(
            color: s.card.withValues(alpha: dark ? 0.78 : 0.88),
            borderRadius: BorderRadius.circular(Radii.xl),
            border: Border.all(color: s.hairline),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // With a centre button the destinations share the width either
              // side of a gap wide enough for it.
              final gap = center == null ? 0.0 : fabSize + Insets.md;
              final slot = (constraints.maxWidth - gap) / items.length;
              final selected = selectedIndex.clamp(0, items.length - 1);
              final plateLeft = selected < half
                  ? slot * selected
                  : slot * selected + gap;

              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    left: plateLeft + (slot - 50) / 2,
                    top: 7,
                    width: 50,
                    height: barHeight - 14,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: dark ? 0.20 : 0.10),
                        borderRadius: BorderRadius.circular(Radii.md),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (center != null && i == half) SizedBox(width: gap),
                        SizedBox(
                          width: slot,
                          child: _Tab(
                            item: items[i],
                            selected: i == selected,
                            onTap: () => onSelect(i),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Insets.md,
        0,
        Insets.md,
        bottomSafe > 0 ? bottomSafe * 0.5 + Insets.sm : Insets.md,
      ),
      child: center == null
          ? bar
          : Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                bar,
                Positioned(
                  top: -fabSize * 0.32,
                  child: _CenterButton(action: center!),
                ),
              ],
            ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({required this.action});
  final CenterAction action;

  @override
  Widget build(BuildContext context) {
    final s = Surfaces.of(context);
    return Tooltip(
      message: action.tooltip,
      child: Pressable(
        onTap: action.onTap,
        scale: 0.9,
        child: Container(
          width: GlassTabBar.fabSize,
          height: GlassTabBar.fabSize,
          decoration: BoxDecoration(
            color: s.action,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: s.canvas, width: 4),
          ),
          child: Icon(action.icon, size: 23, color: s.onAction),
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
