import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/domain/models/cabinet_status.dart';

class CabinetState {
  final List<CabinetStatus> cabinets;
  final int selectedIndex;

  CabinetState({
    required this.cabinets,
    required this.selectedIndex,
  });

  CabinetStatus get currentCabinet => cabinets[selectedIndex];

  CabinetState copyWith({
    List<CabinetStatus>? cabinets,
    int? selectedIndex,
  }) {
    return CabinetState(
      cabinets: cabinets ?? this.cabinets,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class CabinetStatusNotifier extends Notifier<CabinetState> {
  @override
  CabinetState build() {
    return CabinetState(
      cabinets: [
        CabinetStatus(cabinetNumber: "312"), // Assuming original was something else, but let's say 404 and 313
        CabinetStatus(cabinetNumber: "313"),
      ],
      selectedIndex: 0,
    );
  }

  void nextCabinet() {
    final newIndex = (state.selectedIndex + 1) % state.cabinets.length;
    state = state.copyWith(selectedIndex: newIndex);
  }

  void previousCabinet() {
    final newIndex = (state.selectedIndex - 1 + state.cabinets.length) % state.cabinets.length;
    state = state.copyWith(selectedIndex: newIndex);
  }

  void setStatus(bool isOpen, String keyLocation) {
    final updatedCabinets = List<CabinetStatus>.from(state.cabinets);
    updatedCabinets[state.selectedIndex] = state.currentCabinet.copyWith(
      isOpen: isOpen,
      keyLocation: keyLocation,
    );
    state = state.copyWith(cabinets: updatedCabinets);
  }
}

var cabinetStatusProvider =
    NotifierProvider<CabinetStatusNotifier, CabinetState>(
      CabinetStatusNotifier.new,
    );
