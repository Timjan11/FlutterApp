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
    _selectedIds = widget.event.assignedEmployees.map((e) => e.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Назначить сотрудников',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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
              title: Text(emp.name),
              subtitle: Text(emp.position),
              secondary: const Icon(Icons.person, color: Colors.grey),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              dense: true,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
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