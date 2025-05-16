import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/number_checker_cubit.dart';
import '../bloc/number_checker_state.dart';
import 'custom_textfield.dart';
import 'empty_button.dart';


class DeleteCarDialog extends StatefulWidget {
  const DeleteCarDialog({Key? key}) : super(key: key);

  @override
  State<DeleteCarDialog> createState() => _DeleteCarDialogState();
}

class _DeleteCarDialogState extends State<DeleteCarDialog> {
  final _formKey = GlobalKey<FormState>();
  final _plateNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _plateNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final plateNumber = _plateNumberController.text.trim();
    final password = _passwordController.text.trim();

    final cubit = context.read<NumberCheckerCubit>();
    cubit.deleteCar(plateNumber: plateNumber, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NumberCheckerCubit, NumberCheckerState>(
      listener: (context, state) {
        if (state is NumberCheckerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${state.message}')),
          );
        } else if (state is NumberCheckerInitial) {
          // После успешного удаления закрываем диалог и показываем сообщение
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Машина удалена'),
              backgroundColor: Color(0xFF00312C),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ExitCarLoading; // Можно добавить отдельный Loading, если есть

        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Удалить машину'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(controller: _plateNumberController, label: 'Номер машины', required: true),
                  CustomTextField(controller: _passwordController, label: 'Пароль', required: true, obscure: true),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: EmptyButton(
                          title: 'Отмена',
                          onTap: isLoading ? null : () => Navigator.of(context).pop(),
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 180,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : EmptyButton(
                          title: 'Удалить машину',
                          onTap: _submit,
                          color: const Color(0xFFF37B7B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
