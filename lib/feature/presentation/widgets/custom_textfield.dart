import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final bool obscure;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.required = false,
    this.obscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // вертикальные отступы между полями
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Обязательное поле';
          }
          return null;
        },
        decoration: InputDecoration(
          label: Text.rich(
            TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black), // стиль для текста label
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),  // красная звёздочка
                  ),
              ],
            ),
          ),
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // внутренние отступы
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
