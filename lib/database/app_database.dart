import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../domain/models/employee.dart' hide employees;
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
  TextColumn get busyUntil => text().nullable()();
  TextColumn get location => text().nullable()();
}

@DataClassName('EventTableData')
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get type => intEnum<EventType>().withDefault(const Constant(0))();

  DateTimeColumn get startTime => dateTime().nullable()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get location => text().nullable()();
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
  AppDatabase() : super(driftDatabase(
    name: 'university_lab_final_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  ));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 4) {
        await m.addColumn(events, events.startTime);
        await m.addColumn(events, events.endTime);
        await m.addColumn(events, events.location);
      }
      if (from < 5) {
        await m.addColumn(employees, employees.busyUntil);
        await m.addColumn(employees, employees.location);
      }
    },
  );
}