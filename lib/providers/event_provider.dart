import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../domain/models/event.dart';
import '../domain/models/employee.dart' hide employees;
import '../database/app_database.dart';
import '../database/daos/event_dao.dart';
import 'database_provider.dart';

final allEventsProvider = StreamProvider<List<Event>>((ref) {
  final eventDao = ref.watch(eventDaoProvider);

  return eventDao.watchAllEvents().map((list) {
    return list.map((item) {
      final event = item.event;
      final startTime = event.startTime ?? DateTime(event.date.year, event.date.month, event.date.day, 9, 0);
      final endTime = event.endTime ?? DateTime(event.date.year, event.date.month, event.date.day, 18, 0);
      final location = event.location ?? '';

      return Event(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
        startTime: startTime,
        endTime: endTime,
        location: location,
        type: event.type,
        assignedEmployees: item.employees.map((e) => Employee(
          id: e.id.toString(),
          name: e.name,
          position: e.position,
          imagePath: e.imagePath,
          isBusy: e.isBusy,
          status: e.status,
        )).toList(),
      );
    }).toList();
  });
});

  final eventsForDayProvider = StreamProvider.family<List<Event>, DateTime>((ref, day) {
  final eventDao = ref.watch(eventDaoProvider);

  return eventDao.watchEventsForDay(day).map((list) {
    return list.map((item) {
      final event = item.event;
      final startTime = event.startTime ?? DateTime(event.date.year, event.date.month, event.date.day, 9, 0);
      final endTime = event.endTime ?? DateTime(event.date.year, event.date.month, event.date.day, 18, 0);
      final location = event.location ?? '';

      return Event(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
        startTime: startTime,
        endTime: endTime,
        location: location,
        type: event.type,
        assignedEmployees: item.employees.map((e) => Employee(
          id: e.id.toString(),
          name: e.name,
          position: e.position,
          imagePath: e.imagePath,
          isBusy: e.isBusy,
          status: e.status,
        )).toList(),
      );
    }).toList();
  });
});

final eventActionsProvider = Provider((ref) {
  final eventDao = ref.watch(eventDaoProvider);
  return EventActions(eventDao);
});

class EventActions {
  final EventDao _eventDao;
  EventActions(this._eventDao);

  Future<void> addEvent(Event event) async {
    await _eventDao.createEvent(
      EventsCompanion.insert(
        title: event.title,
        description: event.description,
        date: event.date,
        startTime: Value(event.startTime),
        endTime: Value(event.endTime),
        location: Value(event.location),
        type: Value(event.type),
      ),
      event.assignedEmployees.map((e) => int.parse(e.id)).toList(),
    );
  }

  Future<void> updateEvent(Event event) async {
    await _eventDao.updateEvent(
      EventTableData(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
        startTime: event.startTime,
        endTime: event.endTime,
        location: event.location,
        type: event.type,
      ),
      event.assignedEmployees.map((e) => int.parse(e.id)).toList(),
    );
  }

  Future<void> deleteEvent(int eventId) async {
    await _eventDao.deleteEvent(eventId);
  }
}