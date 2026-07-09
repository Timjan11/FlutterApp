import 'package:flutter/material.dart';

enum EmployeeStatus {
  free,    // Свободен
  busy,    // Занят
  away,    // Отошел
  meeting; // На совещании

  String get displayName {
    switch (this) {
      case EmployeeStatus.free:
        return 'Свободен';
      case EmployeeStatus.busy:
        return 'Занят';
      case EmployeeStatus.away:
        return 'Отошел';
      case EmployeeStatus.meeting:
        return 'На совещании';
    }
  }

  Color get color {
    switch (this) {
      case EmployeeStatus.free:
        return Colors.green;
      case EmployeeStatus.busy:
        return Colors.red;
      case EmployeeStatus.away:
        return Colors.orange;
      case EmployeeStatus.meeting:
        return Colors.purple;
    }
  }
}
class Employee {
  final String id;
  final String name;
  final String position;
  final String imagePath;
  final bool isBusy;
  final EmployeeStatus status;


  const Employee({required this.id, required this.name, required this.position, required this.imagePath, required this.isBusy, required this.status});
}

final List<Employee> employees = [
  Employee(id: '0', name: '1', position: 'Начальник', imagePath: 'assets/img/1.png',isBusy: true, status: EmployeeStatus.free),
  Employee(id: '1', name: '2', position: 'Начальник 2', imagePath: 'assets/img/1.png', isBusy: true, status: EmployeeStatus.busy),
  Employee(id: '2', name: '3', position: 'Старший разработчик', imagePath: 'assets/img/1.png', isBusy: false, status: EmployeeStatus.away),
  Employee(id: '3', name: '4', position: 'Frontend разработчик', imagePath: 'assets/img/1.png', isBusy: false, status: EmployeeStatus.meeting),
  Employee(id: '4', name: '5', position: 'UI/UX дизайнер', imagePath: 'assets/img/1.png', isBusy: false, status: EmployeeStatus.away)
];