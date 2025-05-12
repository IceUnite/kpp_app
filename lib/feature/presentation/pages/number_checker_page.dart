import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/person.dart';
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
            Widget resultWidget = const SizedBox.shrink();

            if (state is NumberExists) {
              suffixIcon = const Icon(Icons.check_circle, color: Colors.green);
              resultWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _userInfoCard(
                    context,
                    state.person,
                  ),
                ],
              );
            } else if (state is NumberNotExists) {
              suffixIcon = const Icon(Icons.cancel, color: Colors.red);
              resultWidget = const Text(
                'Номер не найден в базе данных.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              );
            } else if (state is NumberCheckerLoading) {
              suffixIcon = const Icon(Icons.hourglass_top, color: Colors.orange);
              resultWidget = const Center(child: CircularProgressIndicator());
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
                resultWidget,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _userInfoCard(BuildContext context, Person person) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Фамилия: ${person.surname}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Имя: ${person.name}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Отчество: ${person.lastname}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Номер: ${person.number}', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
