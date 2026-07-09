import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/event_provider.dart';
import '../../providers/employeeListProvider.dart';
import '../../domain/models/event.dart';
import '../../domain/models/employee.dart';
import '../widgets/assign_employees_dialog.dart';

class DayDetailScreen extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  const DayDetailScreen({super.key, required this.selectedDate});

  @override
  ConsumerState<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends ConsumerState<DayDetailScreen> {
  final DateFormat dateFormat = DateFormat('d MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsForDayProvider(widget.selectedDate));

    return Scaffold(
      appBar: AppBar(
        title: Text(dateFormat.format(widget.selectedDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEventDialog(context),
          ),
        ],
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Ошибка: $err')),
        data: (eventsForDay) => eventsForDay.isEmpty
            ? const Center(child: Text('Нет мероприятий на этот день'))
            : ListView.builder(
          itemCount: eventsForDay.length,
          itemBuilder: (context, index) {
            final event = eventsForDay[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(event.description),
                    const SizedBox(height: 12),
                    const Text('Назначены:'),
                    Wrap(
                      spacing: 8,
                      children: event.assignedEmployees
                          .map((e) => Chip(
                        label: Text(e.name),
                        avatar: const Icon(Icons.person, size: 16),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _assignEmployees(context, event),
                      icon: const Icon(Icons.people),
                      label: const Text('Назначить сотрудников'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddEventDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новое мероприятие'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (v) => v!.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await ref.read(eventActionsProvider).addEvent(Event(
                  id: 0,
                  title: titleController.text,
                  description: descController.text,
                  date: widget.selectedDate,
                  assignedEmployees: [],
                ));
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  Future<void> _assignEmployees(BuildContext context, Event event) async {
    // Получаем значение из стрим-провайдера. 
    // Если данных еще нет, используем пустой список.
    final allEmployeesAsync = ref.read(employeeListProvider);
    final allEmployees = allEmployeesAsync.value ?? [];

    final result = await showDialog<List<Employee>>(
      context: context,
      builder: (context) => AssignEmployeesDialog(
        event: event,
        allEmployees: allEmployees,
      ),
    );
    if (result != null) {
      await ref.read(eventActionsProvider).updateEvent(event.copyWith(assignedEmployees: result));
    }
  }
}
