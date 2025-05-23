import 'package:flutter/material.dart';

class EmptyButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color color;
  bool isMain;

  EmptyButton({super.key, required this.title, required this.onTap, required this.color, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, // теперь допускает null
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        // side: const BorderSide(color: Colors.white),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          title,
          style: isMain ? const TextStyle(color: Colors.white, fontSize: 20) : const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
