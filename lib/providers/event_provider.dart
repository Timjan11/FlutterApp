import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/models/event.dart';

class EventNotifier extends StateNotifier<List<Event>> {
  EventNotifier() : super([]);

  int _nextId = 1;

  List<Event> getEventsForDay(DateTime day) {
    return state.where((e) =>
    e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day).toList();
  }

  void addEvent(Event event) {
    state = [...state, event];
  }

  void updateEvent(Event updated) {
    final index = state.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      final newList = List<Event>.from(state);
      newList[index] = updated;
      state = newList;
    }
  }

  int getNextId() => _nextId++;
}

final eventProvider = StateNotifierProvider<EventNotifier, List<Event>>((ref) {
  return EventNotifier();
});

final eventsForDayProvider = Provider.family<List<Event>, DateTime>((ref, day) {
  final notifier = ref.watch(eventProvider.notifier);
  return notifier.getEventsForDay(day);
});