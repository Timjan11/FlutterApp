import 'package:flutter/material.dart';

class BottomNavBarItem extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String text;
  final int index;
  final int currentIndex;
  final IconData activeIcon;

  const BottomNavBarItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.text,
    required this.index,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? const Color.fromARGB(255, 0, 81, 255).withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // важно: сжимаем по содержимому
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 20, // уменьшено с 24
                color: isActive
                    ? const Color.fromARGB(255, 0, 81, 255)
                    : const Color.fromARGB(255, 99, 108, 128),
              ),
              const SizedBox(height: 2), // уменьшено с 4
              Text(
                text,
                style: TextStyle(
                  fontSize: 10, // уменьшено с 12
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? const Color.fromARGB(255, 0, 81, 255)
                      : const Color.fromARGB(255, 99, 108, 128),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}