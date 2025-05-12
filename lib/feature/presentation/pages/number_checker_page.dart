import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_button_styles.dart';
import '../../../core/theme/app_textfield_styles.dart';
import '../bloc/number_checker_cubit.dart';
import '../../domain/entities/person.dart';

class NumberCheckerPage extends StatefulWidget {
  @override
  _NumberCheckerPageState createState() => _NumberCheckerPageState();
}

class _NumberCheckerPageState extends State<NumberCheckerPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Проверка номера')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: AppTextFieldStyles.defaultDecoration(hintText: 'Введите номер'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: AppButtonStyles.outlined,
              onPressed: () {
                final number = _controller.text.trim();
                if (number.isNotEmpty) {
                  context.read<NumberCheckerCubit>().checkNumber(number);
                }
              },
              child: const Text('Проверить'),
            ),

            const SizedBox(height: 24),
            BlocBuilder<NumberCheckerCubit, NumberCheckerState>(
              builder: (context, state) {
                if (state is NumberCheckerLoading) {
                  return const CircularProgressIndicator();
                } else if (state is NumberExists) {
                  return _buildResultCard(state.person);
                } else if (state is NumberNotExists) {
                  return _buildResultCard(null);
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Person? person) {
    final bool found = person != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: found ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: found ? Colors.green : Colors.red,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: found
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ Пользователь найден!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text('Фамилия: ${person.surname}'),
          Text('Имя: ${person.name}'),
          Text('Отчество: ${person.lastname}'),
          Text('Номер: ${person.number}'),
        ],
      )
          : Text(
        '❌ Пользователь не найден.',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade800,
        ),
      ),
    );
  }
}
