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
    BottomNavBarItem(icon: Icons.door_back_door_outlined, activeIcon: Icons.door_back_door, text: "Кабинет", index: 2, currentIndex: currentIndex, onTap: onTap),
    BottomNavBarItem(icon: Icons.people_alt_outlined, activeIcon: Icons.people_alt ,text: "Сотрудники", index: 1, currentIndex: currentIndex, onTap: onTap),
    BottomNavBarItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today ,text: "Календарь", index: 0, currentIndex: currentIndex, onTap: onTap),
    BottomNavBarItem(icon: Icons.list_alt_rounded, activeIcon: Icons.list_alt_rounded ,text: "События", index: 3, currentIndex: currentIndex, onTap: onTap),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 85,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 6,
              children: items.toList(),
            ),
          ),
        ),
      ],
    );
  }
}
