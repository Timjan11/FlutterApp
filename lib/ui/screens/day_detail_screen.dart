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
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: event.type.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          event.type.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: event.type.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
    EventType? selectedType;

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
              const SizedBox(height: 12),
              DropdownButtonFormField<EventType>(
                decoration: const InputDecoration(labelText: 'Тип мероприятия'),
                value: selectedType,
                items: EventType.values.map((type) {
                  return DropdownMenuItem<EventType>(
                    value: type,
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: type.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(type.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => selectedType = value,
                validator: (v) => v == null ? 'Выберите тип' : null,
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
              if (formKey.currentState!.validate() && selectedType != null) {
                final newEvent = Event(
                  id: 0, // будет проигнорировано при добавлении
                  title: titleController.text,
                  description: descController.text,
                  date: widget.selectedDate,
                  assignedEmployees: [],
                  type: selectedType!,
                );
                await ref.read(eventActionsProvider).addEvent(newEvent);
                Navigator.pop(context);
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  Future<void> _assignEmployees(BuildContext context, Event event) async {
    final allEmployeesAsync = ref.watch(employeeListProvider);
    // Используем значение из стрима (если ещё нет данных, то пустой список)
    final allEmployees = allEmployeesAsync.value ?? [];

    final result = await showDialog<List<Employee>>(
      context: context,
      builder: (context) => AssignEmployeesDialog(
        event: event,
        allEmployees: allEmployees,
      ),
    );
    if (result != null) {
      final updated = event.copyWith(assignedEmployees: result);
      await ref.read(eventActionsProvider).updateEvent(updated);
    }
  }
}