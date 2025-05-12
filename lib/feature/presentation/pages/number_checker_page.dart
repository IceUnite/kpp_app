import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/number_checker_cubit.dart';

class NumberCheckerPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  NumberCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Проверка номера')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<NumberCheckerCubit, NumberCheckerState>(
          builder: (context, state) {
            Icon? suffixIcon;

            if (state is NumberExists) {
              suffixIcon = const Icon(Icons.check_circle, color: Colors.green);
            } else if (state is NumberNotExists) {
              suffixIcon = const Icon(Icons.cancel, color: Colors.red);
            } else if (state is NumberCheckerLoading) {
              suffixIcon = const Icon(Icons.hourglass_top, color: Colors.orange);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Введите номер для проверки:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Номер',
                    suffixIcon: suffixIcon,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<NumberCheckerCubit>().reset();
                    } else {
                      context.read<NumberCheckerCubit>().checkNumber(value);
                    }
                  },
                ),
                const SizedBox(height: 24),
                if (state is NumberExists) ...[
                  _resultBox(context, 'Номер найден в базе данных', Colors.green),
                ] else if (state is NumberNotExists) ...[
                  _resultBox(context, 'Номер не найден', Colors.red),
                ] else if (state is NumberCheckerLoading) ...[
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _resultBox(BuildContext context, String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
