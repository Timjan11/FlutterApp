part of 'employee_dao.dart';

mixin _$EmployeeDaoMixin on DatabaseAccessor<AppDatabase> {
  $EmployeesTable get employees => attachedDatabase.employees;
  $EventsTable get events => attachedDatabase.events;
  $EventAssignmentsTable get eventAssignments =>
      attachedDatabase.eventAssignments;
  EmployeeDaoManager get managers => EmployeeDaoManager(this);
}

class EmployeeDaoManager {
  final _$EmployeeDaoMixin _db;
  EmployeeDaoManager(this._db);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db.attachedDatabase, _db.employees);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$EventAssignmentsTableTableManager get eventAssignments =>
      $$EventAssignmentsTableTableManager(
        _db.attachedDatabase,
        _db.eventAssignments,
      );
}
