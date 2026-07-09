import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/providers/cabinet_status_notifier.dart';
import 'package:web_corp/ui/widgets/cabinet_status_modal.dart';
import 'package:web_corp/ui/widgets/cabinet_status_widget.dart';

class CabinetStatusScreen extends ConsumerWidget {
  const CabinetStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(cabinetStatusProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 238, 255),
      appBar: AppBar(
        title: Text(
          "WebLab SSTU",
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              spacing: 12,
              children: [
                CabinetStatusWidget(),
                status.isOpen
                    ? Image.asset("assets/img/door-open.png", height: 250)
                    : Image.asset("assets/img/door-closed.png", height: 250),
                if (!status.isOpen)
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
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
                          status.keyLocation,
                          style: theme.textTheme.bodyLarge
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: colorScheme.surface,
            context: context,
            useSafeArea: true,
            builder: (_) => const CabinetStatusModal(),
          );
        },
        child: Icon(Icons.door_back_door_outlined),
      ),
    );
  }
}
