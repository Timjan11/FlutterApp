import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/providers/theme_provider.dart';
import 'package:web_corp/ui/widgets/bottom_nav_bar.dart';

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false, // отключаем автоматическое изменение размера
      appBar: AppBar(
        title: const Text('WebLab SSTU'),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              final isLight = ref.read(themeModeProvider) == ThemeMode.light;
              ref.read(themeModeProvider.notifier).state =
              isLight ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Основное содержимое с отступом снизу для панели
          Padding(
            padding: const EdgeInsets.only(bottom: 90), // оставляем место для NavBar
            child: navigationShell,
          ),
          // Плавающая навигационная панель
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: BottomNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}