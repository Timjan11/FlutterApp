import 'package:flutter/material.dart';

class CabinetStatus {
  bool isOpen;
  String keyLocation;
  final Color color;

  CabinetStatus({
    this.isOpen = false,
    this.keyLocation = "Вахта",
  }) : color = isOpen ? Color.fromARGB(255, 37, 122, 37) : Color.fromARGB(
      255, 220, 54, 54) ;
}
