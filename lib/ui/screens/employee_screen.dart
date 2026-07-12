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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок и кнопка добавления
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сотрудники',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                // Круглая кнопка добавления с иконкой person_add
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.person_add, color: Colors.white),
                    onPressed: () => _showEmployeeDialog(context, ref),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  ),
                ),
              ],
            ),
          ),
          // Список сотрудников
          Expanded(
            child: employeesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Ошибка: $err')),
              data: (list) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: list.length,
                itemBuilder: (context, index) => EmployeeCard(employee: list[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Диалог добавления/редактирования сотрудника (приведён к макету)
  Future<void> _showEmployeeDialog(BuildContext context, WidgetRef ref, {Employee? employee}) async {
    final nameController = TextEditingController(text: employee?.name);
    final positionController = TextEditingController(text: employee?.position);
    final locationController = TextEditingController(text: employee?.location ?? '');
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'ФИО'),
                    validator: (v) => v!.isEmpty ? 'Введите ФИО' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: positionController,
                    decoration: const InputDecoration(labelText: 'Должность'),
                    validator: (v) => v!.isEmpty ? 'Введите должность' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<EmployeeStatus>(
                    value: selectedStatus,
                    decoration: const InputDecoration(labelText: 'Статус'),
                    onChanged: (val) => setDialogState(() => selectedStatus = val!),
                    items: EmployeeStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.displayName),
                    )).toList(),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Занят сейчас'),
                    value: isBusy,
                    onChanged: (val) => setDialogState(() => isBusy = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Местоположение'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
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