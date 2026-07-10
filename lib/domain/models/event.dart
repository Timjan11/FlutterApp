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
        return Colors.blue.shade300;
      case EventType.practice:
        return Colors.green.shade300;
      case EventType.hackathon:
        return Colors.purple.shade300;
    }
  }
}

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final List<Employee> assignedEmployees;
  final EventType type;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.assignedEmployees = const [],
    required this.type,
  });

  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    List<Employee>? assignedEmployees,
    EventType? type,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      assignedEmployees: assignedEmployees ?? this.assignedEmployees,
      type: type ?? this.type,
    );
  }
}