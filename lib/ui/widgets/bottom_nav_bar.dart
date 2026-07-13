import 'package:flutter/material.dart';
import 'package:web_corp/ui/widgets/bottom_nav_bar_item.dart';

class BottomNavBar extends StatelessWidget {
  final Function onTap;
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  List<Widget> get items => [
    BottomNavBarItem(
      icon: Icons.door_back_door_outlined,
      activeIcon: Icons.door_back_door,
      text: "Кабинет",
      index: 2,
      currentIndex: currentIndex,
      onTap: onTap,
    ),
    BottomNavBarItem(
      icon: Icons.people_alt_outlined,
      activeIcon: Icons.people_alt,
      text: "Сотрудники",
      index: 1,
      currentIndex: currentIndex,
      onTap: onTap,
    ),
    BottomNavBarItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      text: "Календарь",
      index: 0,
      currentIndex: currentIndex,
      onTap: onTap,
    ),
    BottomNavBarItem(
      icon: Icons.list_alt_rounded,
      activeIcon: Icons.list_alt_rounded,
      text: "События",
      index: 3,
      currentIndex: currentIndex,
      onTap: onTap,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final Color bgColor = isLight
        ? Colors.white.withValues(alpha: 0.9)
        : Colors.grey.shade800.withValues(alpha: 0.9);

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? 0.1 : 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }
}