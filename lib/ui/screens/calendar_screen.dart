import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/event_provider.dart';
import '../../domain/models/event.dart';

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
      DateTime(date.year, date.month, 1).weekday; // 1 = ПН

  List<DateTime?> _buildDaysList(DateTime month) {
    final daysCount = _daysInMonth(month);
    final firstDay = _firstDayOfMonth(month);
    final List<DateTime?> days = [];
    // Невидимые ячейки перед первым днём
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

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(allEventsProvider);
    final days = _buildDaysList(_focusedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Web-лаборатория ВУЗа'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavButton(Icons.arrow_back_ios, _previousMonth),
                const SizedBox(width: 20),
                Text(
                  _getMonthName(_focusedMonth),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 20),
                _buildNavButton(Icons.arrow_forward_ios, _nextMonth),
              ],
            ),
            const SizedBox(height: 16),
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
            Expanded(
              child: eventsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Ошибка загрузки: $err')),
                data: (events) => _buildGrid(days, events),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<DateTime?> days, List<Event> events) {
    return GridView.builder(
      key: ValueKey(_focusedMonth),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        if (date == null) {
          // Прозрачная ячейка, сохраняющая размер
          return Container(
            margin: const EdgeInsets.all(4),
            color: Colors.transparent,
          );
        }

        final dayEvents = events.where((e) =>
        e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day).toList();

        final bool hasEvents = dayEvents.isNotEmpty;
        final Set<EventType> types = dayEvents.map((e) => e.type).toSet();

        final bool isToday = date.day == DateTime.now().day &&
            date.month == DateTime.now().month &&
            date.year == DateTime.now().year;

        final Color textColor = hasEvents
            ? Colors.black
            : Colors.grey.shade600;

        return GestureDetector(
          onTap: () => context.push('/day/${date.year}-${date.month}-${date.day}'),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isToday ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.transparent, width: 0),
            ),
            child: Stack(
              children: [
                // Число по центру
                Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.white : textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Кружочки внизу (если есть события)
                if (types.isNotEmpty)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: types.map((type) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: type.color,
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}