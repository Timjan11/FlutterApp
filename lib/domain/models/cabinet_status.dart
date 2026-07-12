import 'package:flutter/material.dart';

class CabinetStatus {
  final String cabinetNumber;
  bool isOpen;
  String keyLocation;

  CabinetStatus({
    required this.cabinetNumber,
    this.isOpen = false,
    this.keyLocation = "Вахта",
  });

  Color get color => isOpen 
      ? const Color.fromARGB(255, 37, 122, 37) 
      : const Color.fromARGB(255, 220, 54, 54);

  CabinetStatus copyWith({
    bool? isOpen,
    String? keyLocation,
  }) {
    return CabinetStatus(
      cabinetNumber: cabinetNumber,
      isOpen: isOpen ?? this.isOpen,
      keyLocation: keyLocation ?? this.keyLocation,
    );
  }
}
