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
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: TextStyle(
          color: theme.primaryColor,
          fontSize: 16,
        ),
        filled: true,
        fillColor: isLight ? Colors.white : Colors.grey.shade800,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            width: 1.5,
            color: isLight ? const Color(0xFF6B6B6B) : Colors.grey.shade600,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            width: 2,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }
}