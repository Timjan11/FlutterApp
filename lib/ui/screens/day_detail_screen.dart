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
  final DateFormat dateFormat = DateFormat('d MMMM yyyy', 'ru_RU');
  final DateFormat timeFormat = DateFormat('HH:mm', 'ru_RU');

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsForDayProvider(widget.selectedDate));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bool isPastDay = widget.selectedDate.isBefore(today);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(dateFormat.format(widget.selectedDate)),
        actions: [
          if (!isPastDay)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showEventDialog(context),
            ),
        ],
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Ошибка: $err')),
        data: (eventsForDay) {
          return eventsForDay.isEmpty
              ? const Center(child: Text('Нет мероприятий на этот день'))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: eventsForDay.length,
            itemBuilder: (context, index) {
              final event = eventsForDay[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: event.type.color.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: event.type.color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.type.displayName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          if (!isPastDay)
                            PopupMenuButton<String>(
                              color: theme.cardTheme.color,
                              onSelected: (value) {
                                if (value == 'edit') _showEventDialog(context, event: event);
                                if (value == 'delete') _confirmDelete(context, event);
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'edit', child: Text('Изменить')),
                                const PopupMenuItem(value: 'delete', child: Text('Удалить', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      if (event.location.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 18, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              event.location,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 18),
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people, size: 20, color: Colors.white),
                              const SizedBox(width: 8),
                              const Text(
                                'Назначенные сотрудники',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          if (!isPastDay)
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add, size: 18, color: Colors.black),
                                onPressed: () => _assignEmployees(context, event),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                splashRadius: 18,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (event.assignedEmployees.isNotEmpty)
                        Column(
                          children: event.assignedEmployees.map((e) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          e.position,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isPastDay)
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18),
                                      color: Colors.red.shade400,
                                      onPressed: () {
                                        final updatedEmployees = event.assignedEmployees
                                            .where((emp) => emp.id != e.id)
                                            .toList();
                                        ref.read(eventActionsProvider).updateEvent(
                                          event.copyWith(assignedEmployees: updatedEmployees),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      else
                        const Text(
                          'Нет назначенных сотрудников',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ===================== ДИАЛОГ ДОБАВЛЕНИЯ / РЕДАКТИРОВАНИЯ =====================
  Future<void> _showEventDialog(BuildContext context, {Event? event}) async {
    final titleController = TextEditingController(text: event?.title);
    final descController = TextEditingController(text: event?.description);
    final locationController = TextEditingController(text: event?.location ?? '');
    EventType selectedType = event?.type ?? EventType.lecture;

    TimeOfDay? startTime = event != null
        ? TimeOfDay.fromDateTime(event.startTime)
        : TimeOfDay.now();
    TimeOfDay? endTime = event != null
        ? TimeOfDay.fromDateTime(event.endTime)
        : TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);

    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(event == null ? 'Новое мероприятие' : 'Редактирование'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<EventType>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(labelText: 'Тип'),
                    onChanged: (val) => setDialogState(() => selectedType = val!),
                    items: EventType.values.map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.displayName),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Время начала'),
                    subtitle: Text(startTime != null
                        ? MaterialLocalizations.of(context).formatTimeOfDay(startTime!)
                        : 'Не выбрано'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: startTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setDialogState(() => startTime = picked);
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('Время окончания'),
                    subtitle: Text(endTime != null
                        ? MaterialLocalizations.of(context).formatTimeOfDay(endTime!)
                        : 'Не выбрано'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: endTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setDialogState(() => endTime = picked);
                      }
                    },
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Аудитория / Место'),
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
                  if (startTime == null || endTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Выберите время начала и окончания')),
                    );
                    return;
                  }
                  final startDateTime = DateTime(
                    widget.selectedDate.year,
                    widget.selectedDate.month,
                    widget.selectedDate.day,
                    startTime!.hour,
                    startTime!.minute,
                  );
                  final endDateTime = DateTime(
                    widget.selectedDate.year,
                    widget.selectedDate.month,
                    widget.selectedDate.day,
                    endTime!.hour,
                    endTime!.minute,
                  );
                  if (endDateTime.isBefore(startDateTime)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Время окончания должно быть позже начала')),
                    );
                    return;
                  }

                  final actions = ref.read(eventActionsProvider);
                  if (event == null) {
                    await actions.addEvent(Event(
                      id: 0,
                      title: titleController.text,
                      description: descController.text,
                      date: widget.selectedDate,
                      startTime: startDateTime,
                      endTime: endDateTime,
                      location: locationController.text,
                      assignedEmployees: [],
                      type: selectedType,
                    ));
                  } else {
                    await actions.updateEvent(event.copyWith(
                      title: titleController.text,
                      description: descController.text,
                      startTime: startDateTime,
                      endTime: endDateTime,
                      location: locationController.text,
                      type: selectedType,
                    ));
                  }
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== ПОДТВЕРЖДЕНИЕ УДАЛЕНИЯ =====================
  Future<void> _confirmDelete(BuildContext context, Event event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление'),
        content: Text('Удалить мероприятие "${event.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Удалить', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(eventActionsProvider).deleteEvent(event.id);
      // Обновление произойдёт автоматически через StreamProvider
    }
  }

  // ===================== НАЗНАЧЕНИЕ СОТРУДНИКОВ =====================
  Future<void> _assignEmployees(BuildContext context, Event event) async {
    final result = await showDialog<List<Employee>>(
      context: context,
      builder: (context) => _AssignEmployeesDialogWithStream(event: event),
    );
    if (result != null) {
      await ref.read(eventActionsProvider).updateEvent(
        event.copyWith(assignedEmployees: result),
      );
    }
  }
}

// ===================== ВСПОМОГАТЕЛЬНЫЙ ВИДЖЕТ ДЛЯ ДИАЛОГА НАЗНАЧЕНИЯ =====================
class _AssignEmployeesDialogWithStream extends ConsumerStatefulWidget {
  final Event event;
  const _AssignEmployeesDialogWithStream({required this.event});

  @override
  ConsumerState<_AssignEmployeesDialogWithStream> createState() => _AssignEmployeesDialogWithStreamState();
}

class _AssignEmployeesDialogWithStreamState extends ConsumerState<_AssignEmployeesDialogWithStream> {
  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeeListProvider);
    return employeesAsync.when(
      data: (allEmployees) => AssignEmployeesDialog(
        event: widget.event,
        allEmployees: allEmployees,
      ),
      loading: () => const AlertDialog(
        title: Text('Назначить сотрудников'),
        content: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text('Не удалось загрузить список сотрудников: $err'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}