import 'package:flutter/material.dart';

import '../../../core/resources/pictures_path.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF00312C),
        borderRadius: BorderRadius.circular(12),
      ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(PicturesPaths.logo),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.white,
            indent: 5,
            endIndent: 5,
          ),
          Text(
            'Дежурная \nслужба',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold, // Жирный шрифт
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.start,
          )
        ],
      ),

    );
  }
}