import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

enum NavigationStyle { salomon }

class StylishBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final NavigationStyle style;
  final List<NavigationItem> items;

  const StylishBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.style = NavigationStyle.salomon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return _buildSalomonBar();
  }

  Widget _buildSalomonBar() {
    return SalomonBottomBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      items:
          items
              .map(
                (item) => SalomonBottomBarItem(
                  icon: Icon(item.icon),
                  title: Text(item.label),
                  selectedColor: item.selectedColor ?? Colors.blue,
                  unselectedColor: item.unselectedColor ?? Colors.grey,
                ),
              )
              .toList(),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      itemShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      curve: Curves.easeInOutCubic,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;

  NavigationItem({
    required this.icon,
    required this.label,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
  });
}
