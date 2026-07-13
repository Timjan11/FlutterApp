import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/domain/models/employee.dart';
import 'package:web_corp/providers/employeeListProvider.dart';

class EmployeeCard extends ConsumerStatefulWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  ConsumerState<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends ConsumerState<EmployeeCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: _isTapped ? 4 : 2,
      color: theme.cardTheme.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isTapped = !_isTapped;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/img/1.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: widget.employee.isBusy ? Colors.red : Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.employee.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.employee.position,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Статус: ${widget.employee.isBusy ? "Занят" : "Свободен"}',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.employee.isBusy ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.employee.isBusy && widget.employee.busyUntil != null && widget.employee.busyUntil!.isNotEmpty)
                              Text(
                                'До: ${widget.employee.busyUntil}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            if (widget.employee.location != null && widget.employee.location!.isNotEmpty)
                              Text(
                                'Где: ${widget.employee.location}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') _editEmployee(context);
                      if (value == 'delete') _confirmDelete(context);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Изменить')),
                      const PopupMenuItem(value: 'delete', child: Text('Удалить', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color?.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Личная информация',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${widget.employee.id}',
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  Text(
                    'Должность: ${widget.employee.position}',
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  Text(
                    'Занят: ${widget.employee.isBusy ? "Да" : "Нет"}',
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ),
            crossFadeState: _isTapped ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Future<void> _editEmployee(BuildContext context) async {
    final nameController = TextEditingController(text: widget.employee.name);
    final positionController = TextEditingController(text: widget.employee.position);
    final busyUntilController = TextEditingController(text: widget.employee.busyUntil);
    final locationController = TextEditingController(text: widget.employee.location);
    EmployeeStatus selectedStatus = widget.employee.status;
    bool isBusy = widget.employee.isBusy;
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Редактирование сотрудника'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'ФИО'),
                    validator: (v) => v!.isEmpty ? 'Введите ФИО' : null,
                  ),
                  TextFormField(
                    controller: positionController,
                    decoration: const InputDecoration(labelText: 'Должность'),
                    validator: (v) => v!.isEmpty ? 'Введите должность' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<EmployeeStatus>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(labelText: 'Статус (тег)'),
                    onChanged: (val) => setDialogState(() => selectedStatus = val!),
                    items: EmployeeStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.displayName),
                    )).toList(),
                  ),
                  SwitchListTile(
                    title: const Text('Занят сейчас'),
                    value: isBusy,
                    onChanged: (val) => setDialogState(() => isBusy = val),
                  ),
                  if (isBusy)
                    TextFormField(
                      controller: busyUntilController,
                      decoration: const InputDecoration(labelText: 'Занят до (время/событие)'),
                    ),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Местоположение'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final actions = ref.read(employeeActionsProvider);
                  await actions.updateEmployee(Employee(
                    id: widget.employee.id,
                    name: nameController.text,
                    position: positionController.text,
                    imagePath: widget.employee.imagePath,
                    status: selectedStatus,
                    isBusy: isBusy,
                    busyUntil: busyUntilController.text,
                    location: locationController.text,
                  ));
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление'),
        content: Text('Удалить сотрудника "${widget.employee.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Удалить', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(employeeActionsProvider).deleteEmployee(int.parse(widget.employee.id));
    }
  }
}