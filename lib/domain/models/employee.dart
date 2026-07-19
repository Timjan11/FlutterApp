import 'package:flutter/material.dart';

enum EmployeeStatus {
  free,
  busy,
  away,
  meeting;

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
  final String? busyUntil;
  final String? location;

  const Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.imagePath,
    required this.isBusy,
    required this.status,
    this.busyUntil,
    this.location,
  });
}

final List<Employee> employees = [
  Employee(id: '0', name: 'Гаспарян Эдик Арамович', position: 'Босс', imagePath: 'assets/img/1.png', isBusy: true, status: EmployeeStatus.free, location: 'Каб. 404'),
  Employee(id: '1', name: 'Шонин Денис Владимирович', position: 'Босс 2', imagePath: 'assets/img/1.png', isBusy: true, status: EmployeeStatus.busy, busyUntil: '14:00', location: 'Коворкинг'),
  Employee(id: '2', name: 'Бутков Артем Александрович', position: 'Старший разработчик', imagePath: 'assets/img/1.png', isBusy: false, status: EmployeeStatus.away, location: 'Обед'),
  Employee(id: '3', name: 'Карина', position: 'Frontend разработчик', imagePath: 'assets/img/1.png', isBusy: false, status: EmployeeStatus.meeting, busyUntil: '16:30', location: '107'),
  Employee(id: '4', name: 'Камила', position: 'UI/UX дизайнер', imagePath: 'assets/img/1.png', isBusy: false, status: EmployeeStatus.away, location: '312')
];