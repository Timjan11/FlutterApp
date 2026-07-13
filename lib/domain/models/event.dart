import 'package:flutter/material.dart';
import 'employee.dart';

enum EventType {
  lecture,
  practice,
  hackathon,
}

extension EventTypeExtension on EventType {
  String get displayName {
    switch (this) {
      case EventType.lecture:
        return 'Лекция';
      case EventType.practice:
        return 'Практика';
      case EventType.hackathon:
        return 'Хакатон';
    }
  }

  Color get color {
    switch (this) {
      case EventType.lecture:
        return const Color(0xFF2B7AFA); // яркий синий
      case EventType.practice:
        return const Color(0xFF2E9A6E); // яркий зелёный
      case EventType.hackathon:
        return const Color(0xFF9B59B6); // яркий фиолетовый
    }
  }
}

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final List<Employee> assignedEmployees;
  final EventType type;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.assignedEmployees = const [],
    required this.type,
  });

  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<Employee>? assignedEmployees,
    EventType? type,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      assignedEmployees: assignedEmployees ?? this.assignedEmployees,
      type: type ?? this.type,
    );
  }
}