import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/event_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();

  int _daysInMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0).day;

  int _firstDayOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1).weekday;

  List<DateTime?> _buildDaysList(DateTime month) {
    final daysCount = _daysInMonth(month);
    final firstDay = _firstDayOfMonth(month);
    final List<DateTime?> days = [];
    for (int i = 0; i < firstDay - 1; i++) {
      days.add(null);
    }
    for (int day = 1; day <= daysCount; day++) {
      days.add(DateTime(month.year, month.month, day));
    }
    return days;
  }

  String _getMonthName(DateTime date) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _previousMonth() => setState(() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
  });

  void _nextMonth() => setState(() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
  });

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventProvider);
    final days = _buildDaysList(_focusedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Web-лаборатория ВУЗа'),
        centerTitle: true, // Заголовок по центру (можно убрать, если хотите слева)
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Навигация по месяцам (стрелки и месяц по центру)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 20,
                ),
                const SizedBox(width: 20),
                Text(
                  _getMonthName(_focusedMonth),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.arrow_forward_ios),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Заголовки дней недели
            const Row(
              children: [
                Expanded(child: Center(child: Text('Пн', style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Вт', style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Ср', style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Чт', style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Пт', style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Сб', style: TextStyle(fontWeight: FontWeight.bold)))),
                Expanded(child: Center(child: Text('Вс', style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
            const SizedBox(height: 8),
            // Сетка дней
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final date = days[index];
                  if (date == null) {
                    // Пустая ячейка – светло-серый фон
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }

                  final hasEvents = events.any((e) =>
                  e.date.year == date.year &&
                      e.date.month == date.month &&
                      e.date.day == date.day);

                  final isToday = date.day == DateTime.now().day &&
                      date.month == DateTime.now().month &&
                      date.year == DateTime.now().year;

                  // Определяем цвет фона и текста
                  Color bgColor = Colors.white;
                  Color textColor = Colors.black;
                  if (isToday) {
                    bgColor = Colors.blue;
                    textColor = Colors.white;
                  } else if (hasEvents) {
                    bgColor = Colors.green;
                    textColor = Colors.white;
                  }

                  return GestureDetector(
                    onTap: () => context.push('/day/${date.year}-${date.month}-${date.day}'),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}