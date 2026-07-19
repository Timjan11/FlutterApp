import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../domain/models/employee.dart' as model;

part 'employee_dao.g.dart';

@DriftAccessor(tables: [Employees, EventAssignments])
class EmployeeDao extends DatabaseAccessor<AppDatabase> with _$EmployeeDaoMixin {
  EmployeeDao(super.db);

  Future<List<EmployeeTableData>> getAllEmployees() => select(employees).get();

  Stream<List<EmployeeTableData>> watchAllEmployees() => select(employees).watch();

  Future<void> insertEmployees(List<EmployeesCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(employees, entries, mode: InsertMode.insertOrReplace);
    });
  }

  Future<int> addEmployee(EmployeesCompanion entry) {
    return into(employees).insert(entry);
  }

  Future<bool> updateEmployee(EmployeeTableData entry) {
    return update(employees).replace(entry);
  }

  Future<void> deleteEmployee(int id) async {
    await transaction(() async {
      await (delete(eventAssignments)..where((t) => t.employeeId.equals(id))).go();
      await (delete(employees)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<void> updateEmployeeStatus(int id, model.EmployeeStatus status) async {
    await (update(employees)..where((t) => t.id.equals(id)))
        .write(EmployeesCompanion(status: Value(status)));
  }
}
