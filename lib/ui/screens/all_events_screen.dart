import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../providers/event_provider.dart';
import '../../domain/models/event.dart';

class AllEventsScreen extends ConsumerWidget {
  const AllEventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(allEventsProvider);
    final DateFormat dateFormat = DateFormat('d MMMM', 'ru_RU');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Все мероприятия'),
        centerTitle: true,
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Ошибка: $err')),
        data: (events) {
          if (events.isEmpty) {
            return const Center(child: Text('Список мероприятий пуст'));
          }

          // Сортируем события по дате (от новых к старым)
          final sortedEvents = [...events];
          sortedEvents.sort((a, b) => b.date.compareTo(a.date));

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300, // Ограничиваем максимальную ширину карточки
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1, // Делаем карточки менее вытянутыми в длину
            ),
            itemCount: sortedEvents.length,
            itemBuilder: (context, index) {
              final event = sortedEvents[index];
              return _EventTile(event: event, dateFormat: dateFormat);
            },
          );
        },
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final Event event;
  final DateFormat dateFormat;

  const _EventTile({required this.event, required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/day/${event.date.year}-${event.date.month}-${event.date.day}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: event.type.color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: event.type.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Цветная полоска сверху
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 6,
                child: Container(color: event.type.color),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    // Дата
                    Text(
                      dateFormat.format(event.date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Название
                    Expanded(
                      child: Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Тип (тег)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: event.type.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.type.displayName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: event.type.color.withOpacity(0.8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Место
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: Colors.grey.shade400),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.location.isNotEmpty ? event.location : 'Не указано',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
