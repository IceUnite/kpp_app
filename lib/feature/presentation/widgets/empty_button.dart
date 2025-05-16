import 'package:flutter/material.dart';

class EmptyButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color color;

  const EmptyButton({
    Key? key,
    required this.title,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, // теперь допускает null
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        side: const BorderSide(color: Colors.white),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}
