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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сотрудники',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.person_add, color: Colors.white),
                    onPressed: () => _showEmployeeDialog(context, ref),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: employeesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Ошибка: $err')),
              data: (list) => LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 750) {
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) => EmployeeCard(
                        employee: list[index],
                        isGrid: true,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: list.length,
                      itemBuilder: (context, index) => EmployeeCard(
                        employee: list[index],
                        isGrid: false,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEmployeeDialog(BuildContext context, WidgetRef ref, {Employee? employee}) async {
    final nameController = TextEditingController(text: employee?.name);
    final positionController = TextEditingController(text: employee?.position);
    final busyUntilController = TextEditingController(text: employee?.busyUntil);
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
                    decoration: const InputDecoration(labelText: 'Статус (тег)'),
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
                  if (isBusy)
                    TextFormField(
                      controller: busyUntilController,
                      decoration: const InputDecoration(labelText: 'Занят до'),
                    ),
                  const SizedBox(height: 12),
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
                  final updatedEmployee = Employee(
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
                    await actions.addEmployee(updatedEmployee);
                  } else {
                    await actions.updateEmployee(updatedEmployee);
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
