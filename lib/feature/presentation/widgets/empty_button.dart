import 'package:flutter/material.dart';

class EmptyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color color;

  const EmptyButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.color = const Color(0xFF00312C),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        side: const BorderSide(color: Colors.black),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
