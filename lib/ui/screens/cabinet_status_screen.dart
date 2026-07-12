import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/providers/cabinet_status_notifier.dart';
import 'package:web_corp/ui/widgets/cabinet_status_modal.dart';
import 'package:web_corp/ui/widgets/button_app.dart';

class CabinetStatusScreen extends ConsumerWidget {
  const CabinetStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabinetState = ref.watch(cabinetStatusProvider);
    final currentCabinet = cabinetState.currentCabinet;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ArrowButton(
                  icon: Icons.arrow_back_ios_new,
                  onPressed: () => ref.read(cabinetStatusProvider.notifier).previousCabinet(),
                ),
                const SizedBox(width: 16),
                Text(
                  "Кабинет ${currentCabinet.cabinetNumber}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 33, 33, 33),
                  ),
                ),
                const SizedBox(width: 16),
                _ArrowButton(
                  icon: Icons.arrow_forward_ios,
                  onPressed: () => ref.read(cabinetStatusProvider.notifier).nextCabinet(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Web-лаборатория",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: currentCabinet.color,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                currentCabinet.isOpen ? "Открыто" : "Закрыто",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            currentCabinet.isOpen
                ? Image.asset("assets/img/door-open.png", height: 200)
                : Image.asset("assets/img/door-closed.png", height: 200),
            const SizedBox(height: 24),
            const Text(
              "Местоположение ключа",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              currentCabinet.isOpen
                  ? "Ключ находится в кабинете"
                  : currentCabinet.keyLocation.isNotEmpty
                  ? currentCabinet.keyLocation
                  : "У дежурного на вахте",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 33, 33, 33),
              ),
            ),
            const SizedBox(height: 32),
            ButtonApp(
              text: "Изменить статус",
              color: colorScheme.primary,
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: colorScheme.surface,
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => const CabinetStatusModal(),
                );
              },
              minSize: const Size(double.infinity, 52),
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: const Color.fromARGB(255, 50, 50, 50)),
        onPressed: onPressed,
      ),
    );
  }
}