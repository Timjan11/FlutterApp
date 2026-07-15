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
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.dividerColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isLight ? 0.1 : 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, size: 20, color: theme.iconTheme.color),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(allEventsProvider);
    final days = _buildDaysList(_focusedMonth);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000), // Ограничиваем ширину для ПК
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavButton(Icons.arrow_back_ios, _previousMonth),
                    const SizedBox(width: 20),
                    Text(
                      _getMonthName(_focusedMonth),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 20),
                    _buildNavButton(Icons.arrow_forward_ios, _nextMonth),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (var day in ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'])
                      Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
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
        ),
      ),
    );
  }

  Widget _buildGrid(List<DateTime?> days, List<Event> events) {
    final theme = Theme.of(context);
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
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onSurface.withValues(alpha: 0.5);

        return GestureDetector(
          onTap: () => context.push('/day/${date.year}-${date.month}-${date.day}'),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isToday ? theme.primaryColor : theme.cardTheme.color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.transparent, width: 0),
            ),
            child: Stack(
              children: [
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