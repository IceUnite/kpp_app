import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegionField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const RegionField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 3,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [LengthLimitingTextInputFormatter(3), FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: 'Регион',
          labelStyle: const TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
        ),
        style: const TextStyle(fontSize: 44, letterSpacing: 12),
      ),
    );
  }
}
