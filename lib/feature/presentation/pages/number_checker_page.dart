import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/number_checker_cubit.dart';

class NumberCheckerPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Проверка номера')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<NumberCheckerCubit, NumberCheckerState>(
          builder: (context, state) {
            Icon? suffixIcon;

            if (state is NumberExists) {
              suffixIcon = Icon(Icons.check_circle, color: Colors.green);
            } else if (state is NumberNotExists) {
              suffixIcon = Icon(Icons.cancel, color: Colors.red);
            } else if (state is NumberCheckerLoading) {
              suffixIcon = Icon(Icons.hourglass_top, color: Colors.orange);
            }

            return Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Введите номер',
                    suffixIcon: suffixIcon,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<NumberCheckerCubit>().reset();
                    } else {
                      context.read<NumberCheckerCubit>().checkNumber(value);
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
