import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../domain/models/employee.dart';
import '../domain/models/event.dart';

import 'daos/employee_dao.dart';
import 'daos/event_dao.dart';

part 'app_database.g.dart';

@DataClassName('EmployeeTableData')
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get position => text()();
  TextColumn get imagePath => text()();
  BoolColumn get isBusy => boolean().withDefault(const Constant(false))();
  IntColumn get status => intEnum<EmployeeStatus>()();
}

@DataClassName('EventTableData')
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get type => intEnum<EventType>().withDefault(const Constant(0))();
}

class EventAssignments extends Table {
  IntColumn get eventId => integer().references(Events, #id)();
  IntColumn get employeeId => integer().references(Employees, #id)();
  
  @override
  Set<Column> get primaryKey => {eventId, employeeId};
}

@DriftDatabase(
  tables: [Employees, Events, EventAssignments],
  daos: [EmployeeDao, EventDao],
)
class AppDatabase extends _$AppDatabase {
  // Используем фиксированное имя. drift_flutter автоматически найдет sqlite3.wasm в папке web/
  AppDatabase() : super(driftDatabase(name: 'university_lab_final_db'));

  @override
  int get schemaVersion => 3;
}
