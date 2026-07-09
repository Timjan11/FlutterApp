import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/routing/app_routing.dart';
import 'package:web_corp/theme/app_theme.dart';
import 'package:web_corp/providers/employeeListProvider.dart';

void main() {
  // Убираем await из main, чтобы UI загрузился мгновенно
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();
  
  // Запускаем инициализацию базы "вдогонку"
  container.read(employeeActionsProvider).seedDatabaseIfEmpty().catchError((e) {
    debugPrint('Database seeding failed: $e');
  });

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
