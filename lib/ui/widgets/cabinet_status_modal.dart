import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/providers/cabinet_status_notifier.dart';
import 'package:web_corp/ui/widgets/button_app.dart';
import 'package:web_corp/ui/widgets/text_field_app.dart';

class CabinetStatusModal extends ConsumerStatefulWidget {
  const CabinetStatusModal({super.key});

  @override
  ConsumerState<CabinetStatusModal> createState() => _CabinetStatusModalState();
}

class _CabinetStatusModalState extends ConsumerState<CabinetStatusModal> {
  late bool _tempIsOpen;
  late TextEditingController _keyLocationController;

  final Color _openButtonColor = Color.fromARGB(255, 44, 151, 44);
  final Color _closedButtonColor = Color.fromARGB(255, 255, 60, 60);

  @override
  void initState() {
    super.initState();
    final currentStatus = ref.read(cabinetStatusProvider);
    _tempIsOpen = currentStatus.isOpen;
    _keyLocationController = TextEditingController(
      text: currentStatus.keyLocation.isEmpty
          ? "На вахте"
          : currentStatus.keyLocation,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _keyLocationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14,
          children: [
            Text(
              "Изменить статус кабинета",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(
                _tempIsOpen ? Icons.lock_open : Icons.lock,
                color: _tempIsOpen ? Colors.green : Colors.red,
              ),
              title: Text("Статус кабинета:", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),),
            ),

            ButtonApp(
              onPressed: () => setState(() => _tempIsOpen = true),
              text: "Открыт",
              color: _tempIsOpen ? _openButtonColor : Colors.grey,
              minSize: Size(double.infinity, 48),
              fontSize: 16,
            ),
            ButtonApp(
              onPressed: () => setState(() => _tempIsOpen = false),
              text: "Закрыт",
              color: !_tempIsOpen ? _closedButtonColor : Colors.grey,
              minSize: Size(double.infinity, 48),
              fontSize: 16,
            ),
            const SizedBox(height: 16),
            if (!_tempIsOpen)
              TextFieldApp(
                controller: _keyLocationController,
                hintText: "Местоположение ключа",
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 16,
              children: [
                ButtonApp(
                  text: "Отмена",
                  color: const Color.fromARGB(255, 72, 72, 72),
                  onPressed: () => Navigator.of(context).pop(),
                  minSize: Size(48, 16),
                  paddingV: 18,
                  paddingH: 40,
                  fontSize: 18,
                ),
                ButtonApp(
                  text: "Сохранить",
                  color: colorScheme.primary,
                  onPressed: saveChanges,
                  minSize: Size(48, 16),
                  paddingV: 18,
                  fontSize: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveChanges() {
    ref
        .read(cabinetStatusProvider.notifier)
        .setStatus(_tempIsOpen, _keyLocationController.text);

    Navigator.of(context).pop();
  }
}
