import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/providers/cabinet_status_notifier.dart';
import 'package:web_corp/ui/widgets/cabinet_status_modal.dart';
import 'package:web_corp/ui/widgets/cabinet_status_widget.dart';

class CabinetStatusScreen extends ConsumerWidget {
  const CabinetStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabinetState = ref.watch(cabinetStatusProvider);
    final currentCabinet = cabinetState.currentCabinet;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 238, 255),
      appBar: AppBar(
        title: const Text(
          "WebLab SSTU",
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                spacing: 24,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ArrowButton(
                        icon: Icons.arrow_back_ios_new,
                        onPressed: () => ref.read(cabinetStatusProvider.notifier).previousCabinet(),
                      ),
                      const SizedBox(width: 16),
                      CabinetStatusWidget(),
                      const SizedBox(width: 16),
                      _ArrowButton(
                        icon: Icons.arrow_forward_ios,
                        onPressed: () => ref.read(cabinetStatusProvider.notifier).nextCabinet(),
                      ),
                    ],
                  ),
                  currentCabinet.isOpen
                      ? Image.asset("assets/img/door-open.png", height: 250)
                      : Image.asset("assets/img/door-closed.png", height: 250),
                  if (!currentCabinet.isOpen)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(43, 158, 158, 158),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        spacing: 8,
                        children: [
                          Text(
                            "Местоположение ключа:",
                            style: theme.textTheme.titleMedium
                          ),
                          Text(
                            currentCabinet.keyLocation,
                            style: theme.textTheme.bodyLarge
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: colorScheme.surface,
            context: context,
            useSafeArea: true,
            builder: (_) => const CabinetStatusModal(),
          );
        },
        child: const Icon(Icons.door_back_door_outlined),
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
