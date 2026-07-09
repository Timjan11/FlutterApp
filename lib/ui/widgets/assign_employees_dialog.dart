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
  late Set<Employee> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.event.assignedEmployees.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Назначить сотрудников'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.allEmployees.length,
          itemBuilder: (context, index) {
            final emp = widget.allEmployees[index];
            final isSelected = _selected.contains(emp);
            return CheckboxListTile(
              title: Text(emp.name),
              value: isSelected,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selected.add(emp);
                  } else {
                    _selected.remove(emp);
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
            Navigator.pop(context, _selected.toList());
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}