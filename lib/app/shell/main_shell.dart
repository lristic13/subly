import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

/// Main shell with the Ledger bottom tab bar: Home, Subscriptions,
/// Insights, and Add (which pushes the add flow instead of switching tabs).
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: c.bg,
          border: Border(top: BorderSide(color: c.tabDivider)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TabIcon(
                  icon: CupertinoIcons.house,
                  active: navigationShell.currentIndex == 0,
                  onTap: () => _goBranch(0),
                ),
                _TabIcon(
                  icon: CupertinoIcons.line_horizontal_3,
                  active: navigationShell.currentIndex == 1,
                  onTap: () => _goBranch(1),
                ),
                _TabIcon(
                  icon: CupertinoIcons.chart_bar,
                  active: navigationShell.currentIndex == 2,
                  onTap: () => _goBranch(2),
                ),
                _TabIcon(
                  icon: CupertinoIcons.add_circled,
                  size: 26,
                  active: false,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/subscriptions/add');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goBranch(int index) {
    HapticFeedback.selectionClick();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({
    required this.icon,
    required this.active,
    required this.onTap,
    this.size = 24,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.ledgerColors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Icon(
          icon,
          size: size,
          color: active ? c.accentText : c.iconInactive,
        ),
      ),
    );
  }
}
