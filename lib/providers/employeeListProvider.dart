import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/employee.dart';

final employeeListProvider = Provider<List<Employee>>((ref) {
  return employees;
});