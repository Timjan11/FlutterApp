part of 'event_dao.dart';

mixin _$EventDaoMixin on DatabaseAccessor<AppDatabase> {
  $EventsTable get events => attachedDatabase.events;
  $EmployeesTable get employees => attachedDatabase.employees;
  $EventAssignmentsTable get eventAssignments =>
      attachedDatabase.eventAssignments;
  EventDaoManager get managers => EventDaoManager(this);
}

class EventDaoManager {
  final _$EventDaoMixin _db;
  EventDaoManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db.attachedDatabase, _db.events);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db.attachedDatabase, _db.employees);
  $$EventAssignmentsTableTableManager get eventAssignments =>
      $$EventAssignmentsTableTableManager(
        _db.attachedDatabase,
        _db.eventAssignments,
      );
}
