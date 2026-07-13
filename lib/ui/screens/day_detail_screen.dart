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

  Color _getTextColor(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    final lightness = (hsl.lightness - 0.35).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsForDayProvider(widget.selectedDate));
    
    // Проверка: является ли день прошедшим (сравниваем только даты без времени)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bool isPastDay = widget.selectedDate.isBefore(today);

    return Scaffold(
      appBar: AppBar(
        title: Text(dateFormat.format(widget.selectedDate)),
        actions: [
          // Показываем кнопку добавления только если день НЕ прошедший
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
            itemCount: eventsForDay.length,
            itemBuilder: (context, index) {
              final event = eventsForDay[index];
              final textColor = _getTextColor(event.type.color);

              return Card(
                color: event.type.color.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: event.type.color, width: 2),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Тип + меню
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.type.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          if (!isPastDay)
                            PopupMenuButton<String>(
                              color: Colors.white,
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.description,
                        style: TextStyle(color: textColor),
                      ),
                      const SizedBox(height: 8),
                      // Время
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: textColor),
                          const SizedBox(width: 4),
                          Text(
                            '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      if (event.location.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: textColor),
                            const SizedBox(width: 4),
                            Text(
                              event.location,
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      Divider(color: textColor.withValues(alpha: 0.3), thickness: 1),
                      const SizedBox(height: 12),

                      // ---- Назначенные сотрудники (заголовок + кнопка +) ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people, size: 18, color: textColor),
                              const SizedBox(width: 8),
                              Text(
                                'Назначенные сотрудники',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add, size: 16, color: Colors.black),
                                onPressed: () => _assignEmployees(context, event),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                splashRadius: 16,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ---- Список сотрудников с белыми контейнерами (без аватара) ----
                      if (event.assignedEmployees.isNotEmpty)
                        Column(
                          children: event.assignedEmployees.map((e) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
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
                                          ),
                                        ),
                                        Text(
                                          e.position,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isPastDay)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16.0),
                                      child: IconButton(
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
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Text(
                          'Нет назначенных сотрудников',
                          style: TextStyle(color: textColor.withValues(alpha: 0.6)),
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

  // ---------------------- Диалог создания/редактирования ----------------------
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
    }
  }

  Future<void> _assignEmployees(BuildContext context, Event event) async {
    final result = await showDialog<List<Employee>>(
      context: context,
      builder: (context) => _AssignEmployeesDialogWithStream(event: event),
    );
    if (result != null) {
      await ref.read(eventActionsProvider).updateEvent(event.copyWith(assignedEmployees: result));
    }
  }
}

// --------------------- Вспомогательный виджет для диалога назначения ---------------------
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
      data: (allEmployees) {
        return AssignEmployeesDialog(
          event: widget.event,
          allEmployees: allEmployees,
        );
      },
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