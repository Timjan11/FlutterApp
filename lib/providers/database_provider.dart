import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/daos/employee_dao.dart';
import '../database/daos/event_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final employeeDaoProvider = Provider<EmployeeDao>((ref) {
  return ref.watch(databaseProvider).employeeDao;
});

final eventDaoProvider = Provider<EventDao>((ref) {
  return ref.watch(databaseProvider).eventDao;
});
