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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black),
              children: required
                  ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                  : [],
            ),
          ),
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) => value == null || value.isEmpty ? 'Обязательное поле' : null
            : null,
      ),
    );
  }
}
