import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final bool obscure;
  double verticalPadding;
  double horisontalPadding;
  double borderRadius;
  bool isAlert;

  CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.obscure = false,
    this.verticalPadding = 12,
    this.horisontalPadding = 16,
    this.borderRadius = 8,
    this.isAlert = true,
  });

  bool get isPlateNumberField => label.toLowerCase().contains('номер');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isAlert ? const EdgeInsets.symmetric(vertical: 8) : const EdgeInsets.symmetric(vertical: 0),
      child: TextFormField(
        style: isAlert ? const TextStyle(fontSize: 24) : const TextStyle(fontSize: 30),
        controller: controller,
        obscureText: isAlert ? true : obscure,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: isAlert ? 1 : 3, // Автоматически растёт по мере ввода
        inputFormatters: isAlert
            ? isPlateNumberField
            ? [
          FilteringTextInputFormatter.allow(RegExp(r'[а-яА-Я0-9]')),
          UpperCaseTextFormatter(),
          LengthLimitingTextInputFormatter(9),
        ]
            : [LengthLimitingTextInputFormatter(1000)] // Увеличь лимит, если нужно
            : null,
        textCapitalization: isPlateNumberField ? TextCapitalization.characters : TextCapitalization.none,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Обязательное поле';
          }

          if (isPlateNumberField && value != null && value.isNotEmpty) {
            final regExp1 = RegExp(r'^[А-Я]{1}[0-9]{3}[А-Я]{2}[0-9]{1,3}$');
            final regExp2 = RegExp(r'^[0-9]{4}[А-Я]{2}[0-9]{1,3}$');

            if (!regExp1.hasMatch(value) && !regExp2.hasMatch(value)) {
              return 'Формат: А111АА1–3 или 1111АА1–3';
            }
          }

          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: horisontalPadding, vertical: verticalPadding),
          label: Text.rich(
            TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black),
              children: [if (required) const TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
            ),
          ),
          labelStyle: isAlert ? const TextStyle(color: Colors.black87) : const TextStyle(fontSize: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),

    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
