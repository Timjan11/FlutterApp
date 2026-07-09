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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? Color.fromARGB(255, 0, 81, 255).withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? Color.fromARGB(255, 0, 81, 255) : Color.fromARGB(
                    255, 99, 108, 128),
              ),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? const Color.fromARGB(255, 0, 81, 255)
                      : Color.fromARGB(
                      255, 99, 108, 128),
                ),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
