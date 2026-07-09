import 'package:flutter/material.dart';

class TextFieldApp extends StatelessWidget {
  const TextFieldApp({
    super.key,
    this.controller,
    this.hintText,
    this.isObscure = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,

      style: const TextStyle(
        color: Color.fromARGB(255, 70, 70, 70),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(
        labelText: hintText,

        labelStyle: TextStyle(
          color: Color.fromARGB(255, 70, 70, 70),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),

        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 81, 255),
          fontSize: 16,
        ),

        filled: true,
        fillColor: Colors.white,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            width: 1.5,
            color: Color.fromARGB(255, 107, 107, 107),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            width: 2,
            color: Color.fromARGB(255, 0, 81, 255),
          ),
        ),
      ),
    );
  }
}
