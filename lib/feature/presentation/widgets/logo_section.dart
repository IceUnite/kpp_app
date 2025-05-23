import 'package:flutter/material.dart';
import '../../../core/resources/pictures_path.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF00312C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(PicturesPaths.logo),

          // Вертикальный разделитель
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: 1,
            height: 60,
            color: Colors.white,
          ),

          // Текст
          const Text(
            'Дежурная \nслужба',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
