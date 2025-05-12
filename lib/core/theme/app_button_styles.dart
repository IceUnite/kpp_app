import 'package:flutter/material.dart';

class AppButtonStyles {
  static ButtonStyle outlined = OutlinedButton.styleFrom(
    foregroundColor: Colors.deepPurple,
    side: const BorderSide(color: Colors.deepPurple, width: 2),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
}
