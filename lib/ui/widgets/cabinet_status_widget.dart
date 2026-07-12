import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/providers/cabinet_status_notifier.dart';

class CabinetStatusWidget extends ConsumerWidget {
  const CabinetStatusWidget({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref){
    var cabinetState = ref.watch(cabinetStatusProvider);
    var currentCabinet = cabinetState.currentCabinet;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: currentCabinet.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "Кабинет ${currentCabinet.cabinetNumber} ${currentCabinet.isOpen ? 'открыт' : 'закрыт'}",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white
        )
      ),
    );
  }
}