import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/employee.dart';
import '../../providers/employeeListProvider.dart';
import '../widgets/employee_card.dart';

class EmployeeScreen extends ConsumerWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeeListProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Сотрудники'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showEmployeeDialog(context, ref),
          ),
        ],
      ),
      body: employeesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Ошибка: $err')),
        data: (list) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) => EmployeeCard(employee: list[index]),
        ),
      ),
    );
  }

  Future<void> _showEmployeeDialog(BuildContext context, WidgetRef ref, {Employee? employee}) async {
    final nameController = TextEditingController(text: employee?.name);
    final positionController = TextEditingController(text: employee?.position);
    final busyUntilController = TextEditingController(text: employee?.busyUntil);
    final locationController = TextEditingController(text: employee?.location);
    EmployeeStatus selectedStatus = employee?.status ?? EmployeeStatus.free;
    bool isBusy = employee?.isBusy ?? false;
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(employee == null ? 'Новый сотрудник' : 'Редактирование'),
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
                    value: selectedStatus,
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
                  final newEmployee = Employee(
                    id: employee?.id ?? '0',
                    name: nameController.text,
                    position: positionController.text,
                    imagePath: 'assets/img/1.png',
                    status: selectedStatus,
                    isBusy: isBusy,
                    busyUntil: busyUntilController.text,
                    location: locationController.text,
                  );

                  if (employee == null) {
                    await actions.addEmployee(newEmployee);
                  } else {
                    await actions.updateEmployee(newEmployee);
                  }
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
}
