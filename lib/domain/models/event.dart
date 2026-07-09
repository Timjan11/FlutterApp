import 'employee.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final List<Employee> assignedEmployees;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.assignedEmployees = const [],
  });

  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    List<Employee>? assignedEmployees,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      assignedEmployees: assignedEmployees ?? this.assignedEmployees,
    );
  }
}