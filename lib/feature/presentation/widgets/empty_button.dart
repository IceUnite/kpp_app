
import 'package:flutter/material.dart';

class EmptyButton extends StatelessWidget {
  const EmptyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00312C),
        side: const BorderSide(color: Colors.white),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const SizedBox(),
    );
  }
}