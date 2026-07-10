import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
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
  AppDatabase() : super(driftDatabase(
    name: 'lab_db_final', // Снова меняем имя, чтобы избежать кеша
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  ));

  @override
  int get schemaVersion => 3;
}
