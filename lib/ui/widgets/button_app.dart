import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {
  const ButtonApp({super.key, this.onPressed, required this.text, required this.color, this.paddingH=24, this.paddingV=12, this.minSize, this.fontSize=20});

  final VoidCallback? onPressed;
  final String text;
  final Color color;
  final double paddingH;
  final double paddingV;
  final Size? minSize;

  final double fontSize;

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        elevation: 5,
        shadowColor: Color.fromARGB(255, 1, 1, 1),
        minimumSize: minSize,
      ),
      onPressed: onPressed,
      onFocusChange: (value) => Colors.grey, 
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1,
        )
      ),
    );
  }
}