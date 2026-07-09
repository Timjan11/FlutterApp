import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/daos/employee_dao.dart';
import '../database/daos/event_dao.dart';

// Провайдер для доступа к базе данных
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Провайдер для EmployeeDao
final employeeDaoProvider = Provider<EmployeeDao>((ref) {
  return ref.watch(databaseProvider).employeeDao;
});

// Провайдер для EventDao
final eventDaoProvider = Provider<EventDao>((ref) {
  return ref.watch(databaseProvider).eventDao;
});
