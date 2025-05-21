import 'package:flutter/material.dart';

import '../bloc/number_checker_cubit.dart';
import '../bloc/number_checker_state.dart';

class CheckResult extends StatelessWidget {
  final NumberCheckerState state;

  const CheckResult({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is NumberExists) {
      final person = (state as NumberExists).person;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color(0xFF00312C).withOpacity(0.15),
          border: Border.all(color: Color(0xFF00312C), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✅ Пользователь найден!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00312C)),
            ),
            const SizedBox(height: 8),
            person?.surname != null
                ? Text(
                  'Фамилия: ${person!.surname}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFF00312C)),
                )
                : SizedBox.shrink(),
            person?.name != null
                ? Text(
                  'Имя: ${person!.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFF00312C)),
                )
                : SizedBox.shrink(),
            person?.lastname != null
                ? Text(
                  'Отчество: ${person!.lastname}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFF00312C)),
                )
                : SizedBox.shrink(),
            person?.passportData != null
                ? Text(
                  'Паспортные данные: ${person!.passportData}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFF00312C)),
                )
                : SizedBox.shrink(),
            person?.brand != null
                ? Text(
                  'Марка автомобиля: ${person!.brand}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFF00312C)),
                )
                : SizedBox.shrink(),
            person?.organization != null
                ? Text(
                  'Организация: ${person!.organization}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFF00312C)),
                )
                : SizedBox.shrink(),
          ],
        ),
      );
    } else if (state is NumberNotExists) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '❌ Пользователь не найден.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade900),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
