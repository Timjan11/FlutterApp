import 'package:flutter/material.dart';
import '../../domain/models/event.dart';
import '../../domain/models/employee.dart';

class AssignEmployeesDialog extends StatefulWidget {
  final Event event;
  final List<Employee> allEmployees;

  const AssignEmployeesDialog({
    super.key,
    required this.event,
    required this.allEmployees,
  });

  @override
  State<AssignEmployeesDialog> createState() => _AssignEmployeesDialogState();
}

class _AssignEmployeesDialogState extends State<AssignEmployeesDialog> {
  late Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    // Сохраняем только ID выбранных сотрудников
    _selectedIds = widget.event.assignedEmployees.map((e) => e.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Назначить сотрудников'),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.allEmployees.isEmpty 
          ? const Center(child: Text('Список сотрудников пуст'))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.allEmployees.length,
              itemBuilder: (context, index) {
                final emp = widget.allEmployees[index];
                final isSelected = _selectedIds.contains(emp.id);
                return CheckboxListTile(
                  title: Text(emp.name),
                  subtitle: Text(emp.position),
                  value: isSelected,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedIds.add(emp.id);
                      } else {
                        _selectedIds.remove(emp.id);
                      }
                    });
                  },
                );
              },
            ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            // Возвращаем список объектов Employee на основе выбранных ID
            final result = widget.allEmployees
                .where((e) => _selectedIds.contains(e.id))
                .toList();
            Navigator.pop(context, result);
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
