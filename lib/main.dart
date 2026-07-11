import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
import 'package:web_corp/routing/app_routing.dart';
import 'package:web_corp/theme/app_theme.dart';
import 'package:web_corp/providers/employeeListProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация локализации для русского языка
  await initializeDateFormatting('ru_RU', null);

  final container = ProviderContainer();

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
      title: 'WebLab SSTU',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ru', 'RU'),
    );
  }
}