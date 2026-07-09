import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../domain/models/employee.dart' as model;

part 'event_dao.g.dart';

class EventWithEmployees {
  final EventTableData event;
  final List<EmployeeTableData> employees;
  EventWithEmployees({required this.event, required this.employees});
}

@DriftAccessor(tables: [Events, Employees, EventAssignments])
class EventDao extends DatabaseAccessor<AppDatabase> with _$EventDaoMixin {
  EventDao(super.db);

  Future<List<EventWithEmployees>> getAllEventsWithEmployees() async {
    final eventsList = await select(events).get();
    return Future.wait(eventsList.map((event) async {
      final query = select(employees).join([
        innerJoin(eventAssignments, eventAssignments.employeeId.equalsExp(employees.id)),
      ])..where(eventAssignments.eventId.equals(event.id));
      final rows = await query.get();
      return EventWithEmployees(
        event: event, 
        employees: rows.map((row) => row.readTable(employees)).toList()
      );
    }));
  }

  Future<void> createEvent(EventsCompanion eventEntry, List<int> employeeIds) async {
    await transaction(() async {
      final eventId = await into(events).insert(eventEntry);
      for (final id in employeeIds) {
        await into(eventAssignments).insert(EventAssignmentsCompanion.insert(eventId: eventId, employeeId: id));
      }
    });
  }

  Future<void> updateEvent(EventTableData eventData, List<int> employeeIds) async {
    await transaction(() async {
      await update(events).replace(eventData);
      await (delete(eventAssignments)..where((t) => t.eventId.equals(eventData.id))).go();
      for (final id in employeeIds) {
        await into(eventAssignments).insert(EventAssignmentsCompanion.insert(eventId: eventData.id, employeeId: id));
      }
    });
  }

  Stream<List<EventWithEmployees>> watchAllEvents() {
    return select(events).watch().asyncMap((eventsList) async {
      return Future.wait(eventsList.map((event) async {
        final query = select(employees).join([
          innerJoin(eventAssignments, eventAssignments.employeeId.equalsExp(employees.id)),
        ])..where(eventAssignments.eventId.equals(event.id));
        final rows = await query.get();
        return EventWithEmployees(event: event, employees: rows.map((row) => row.readTable(employees)).toList());
      }));
    });
  }

  Stream<List<EventWithEmployees>> watchEventsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (select(events)..where((t) => t.date.isBetweenValues(start, end)))
      .watch().asyncMap((eventsList) async {
        return Future.wait(eventsList.map((event) async {
          final query = select(employees).join([
            innerJoin(eventAssignments, eventAssignments.employeeId.equalsExp(employees.id)),
          ])..where(eventAssignments.eventId.equals(event.id));
          final rows = await query.get();
          return EventWithEmployees(event: event, employees: rows.map((row) => row.readTable(employees)).toList());
        }));
      });
  }
}
