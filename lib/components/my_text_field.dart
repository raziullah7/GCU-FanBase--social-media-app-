import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        // appearance of the text field before clicking on it (non-focused)
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),

        // appearance of the text field after clicking on it (focused)
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),

        // hint text and its styling
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),

        // filling the text field with color grey[200]
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }
}
