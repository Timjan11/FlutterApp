import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../domain/models/employee.dart' hide employees;
import '../domain/models/employee.dart' as model;
import '../database/app_database.dart';
import '../database/daos/employee_dao.dart';
import 'database_provider.dart';

final employeeListProvider = StreamProvider<List<model.Employee>>((ref) {
  final employeeDao = ref.watch(employeeDaoProvider);

  return employeeDao.watchAllEmployees().map((list) {
    return list.map((e) => model.Employee(
      id: e.id.toString(),
      name: e.name,
      position: e.position,
      imagePath: e.imagePath,
      isBusy: e.isBusy,
      status: e.status,
    )).toList();
  });
});

final employeeActionsProvider = Provider((ref) {
  final employeeDao = ref.watch(employeeDaoProvider);
  return EmployeeActions(employeeDao);
});

class EmployeeActions {
  final EmployeeDao _employeeDao;
  EmployeeActions(this._employeeDao);

  Future<void> seedDatabaseIfEmpty() async {
    final current = await _employeeDao.getAllEmployees();
    if (current.isEmpty) {
      await _employeeDao.insertEmployees(
        model.employees.map((e) => EmployeesCompanion.insert(
          name: e.name,
          position: e.position,
          imagePath: e.imagePath,
          status: e.status,
          isBusy: Value(e.isBusy),
        )).toList(),
      );
    }
  }
}
