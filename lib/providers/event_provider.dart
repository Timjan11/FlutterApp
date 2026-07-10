import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../domain/models/event.dart';
import '../domain/models/employee.dart' hide employees;
import '../database/app_database.dart';
import '../database/daos/event_dao.dart';
import 'database_provider.dart';

// Стрим-провайдер для всех мероприятий
final allEventsProvider = StreamProvider<List<Event>>((ref) {
  // В вебе, если нет WASM файлов, возвращаем пустой поток сразу, чтобы не висеть
  if (kIsWeb) {
    return Stream.value([]);
  }

  final eventDao = ref.watch(eventDaoProvider);
  return eventDao.watchAllEvents().map((list) {
    return list.map((item) => Event(
      id: item.event.id,
      title: item.event.title,
      description: item.event.description,
      date: item.event.date,
      assignedEmployees: item.employees.map((e) => Employee(
        id: e.id.toString(),
        name: e.name,
        position: e.position,
        imagePath: e.imagePath,
        isBusy: e.isBusy,
        status: e.status,
      )).toList(),
      // 👇 Временное значение, пока нет поля в БД
      type: EventType.lecture,
    )).toList();
  });
});

// Стрим-провайдер для мероприятий на день
final eventsForDayProvider = StreamProvider.family<List<Event>, DateTime>((ref, day) {
  if (kIsWeb) return Stream.value([]);

  final eventDao = ref.watch(eventDaoProvider);
  return eventDao.watchEventsForDay(day).map((list) {
    return list.map((item) => Event(
      id: item.event.id,
      title: item.event.title,
      description: item.event.description,
      date: item.event.date,
      assignedEmployees: item.employees.map((e) => Employee(
        id: e.id.toString(),
        name: e.name,
        position: e.position,
        imagePath: e.imagePath,
        isBusy: e.isBusy,
        status: e.status,
      )).toList(),
      // 👇 Временное значение, пока нет поля в БД
      type: EventType.lecture,
    )).toList();
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
    if (kIsWeb) return;
    await _eventDao.createEvent(
      EventsCompanion.insert(
        title: event.title,
        description: event.description,
        date: event.date,
      ),
      event.assignedEmployees.map((e) => int.parse(e.id)).toList(),
    );
  }

  Future<void> updateEvent(Event event) async {
    if (kIsWeb) return;
    await _eventDao.updateEvent(
      EventTableData(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
      ),
      event.assignedEmployees.map((e) => int.parse(e.id)).toList(),
    );
  }
}