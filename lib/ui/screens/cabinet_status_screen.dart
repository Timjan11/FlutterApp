import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/providers/cabinet_status_notifier.dart';
import 'package:web_corp/ui/widgets/cabinet_status_modal.dart';

class CabinetStatusScreen extends ConsumerWidget {
  const CabinetStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabinetState = ref.watch(cabinetStatusProvider);
    final cabinets = cabinetState.cabinets;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 238, 255),
      appBar: AppBar(
        title: const Text("Кабинеты лаборатории"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 0.85,
        ),
        itemCount: cabinets.length,
        itemBuilder: (context, index) {
          final cabinet = cabinets[index];
          return GestureDetector(
            onTap: () {
              // Устанавливаем выбранный индекс перед открытием модалки
              ref.read(cabinetStatusProvider.notifier).selectCabinet(index);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => const CabinetStatusModal(),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Шапка карточки с номером
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Каб. ${cabinet.cabinetNumber}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: cabinet.isOpen ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cabinet.isOpen ? "ОТКРЫТ" : "ЗАКРЫТ",
                            style: TextStyle(
                              color: cabinet.isOpen ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Изображение двери со светло-коричневым фильтром
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),


                        child: Image.asset(
                          cabinet.isOpen ? "assets/img/охранник-открывает-дверь.jpg" : "assets/img/охранник-мем.jpg",
                          fit: BoxFit.contain,
                        ),

                    ),
                  ),

                  // Информация о ключе
                  if (!cabinet.isOpen)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Ключ:",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              cabinet.keyLocation.isNotEmpty ? cabinet.keyLocation : "На вахте",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
