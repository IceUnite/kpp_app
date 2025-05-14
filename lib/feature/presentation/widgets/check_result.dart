import 'package:flutter/material.dart';

import '../bloc/number_checker_cubit.dart';

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
          color: Colors.green.shade50,
          border: Border.all(color: Colors.green.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✅ Пользователь найден!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
            const SizedBox(height: 8),
            Text('Фамилия: ${person.surname}'),
            Text('Имя: ${person.name}'),
            Text('Отчество: ${person.lastname}'),
            Text('Номер: ${person.number}'),
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


