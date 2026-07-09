import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_corp/domain/models/cabinet_status.dart';

class CabinetStatusNotifier extends Notifier<CabinetStatus> {
  @override
  CabinetStatus build() {
    return CabinetStatus();
  }

  void setStatus(bool isOpen, String keyLocation) {
    state = CabinetStatus(isOpen: isOpen, keyLocation: keyLocation);
  }
}

var cabinetStatusProvider =
    NotifierProvider<CabinetStatusNotifier, CabinetStatus>(
      CabinetStatusNotifier.new,
    );
