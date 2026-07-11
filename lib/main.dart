import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/routing/app_routing.dart';
import 'package:web_corp/theme/app_theme.dart';
import 'package:web_corp/providers/employeeListProvider.dart';

void main() async {
  // 1. Ждем инициализации Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();
  
  // 2. Ждем, пока база данных прогрузится и наполнятся начальные данные
  try {
    debugPrint('Начало инициализации базы данных...');
    await container.read(employeeActionsProvider).seedDatabaseIfEmpty();
    debugPrint('База данных успешно инициализирована и наполнена');
  } catch (e) {
    debugPrint('Ошибка при инициализации БД: $e');
  }

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
