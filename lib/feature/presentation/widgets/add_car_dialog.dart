import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/number_checker_cubit.dart';
import '../bloc/number_checker_state.dart';
import 'custom_textfield.dart';
import 'empty_button.dart';

class AddCarDialog extends StatefulWidget {
  const AddCarDialog({Key? key}) : super(key: key);

  @override
  State<AddCarDialog> createState() => _AddCarDialogState();
}

class _AddCarDialogState extends State<AddCarDialog> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _brandController = TextEditingController();
  final _passportController = TextEditingController();
  final _organizationController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _plateNumberController.dispose();
    _passwordController.dispose();
    _brandController.dispose();
    _passportController.dispose();
    _organizationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<NumberCheckerCubit>();

    cubit.addCar(
      lastName: _lastNameController.text.trim(),
      firstName: _firstNameController.text.trim(),
      middleName: _middleNameController.text.trim(),
      plateNumber: _plateNumberController.text.trim(),
      password: _passwordController.text.trim(),
      brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
      passportData: _passportController.text.trim().isEmpty ? null : _passportController.text.trim(),
      organization: _organizationController.text.trim().isEmpty ? null : _organizationController.text.trim(),
    );
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
          // Предполагается, что возвращение в Initial состояние после успешного добавления
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Машина добавлена'),
              backgroundColor: Color(0xFF00312C),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AdmitCarLoading;

        return AlertDialog(
          title: const Text('Добавить машину'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(controller: _lastNameController, label: 'Фамилия', required: true),
                  CustomTextField(controller: _firstNameController, label: 'Имя', required: true),
                  CustomTextField(controller: _middleNameController, label: 'Отчество', required: true),
                  CustomTextField(controller: _plateNumberController, label: 'Номер машины', required: true),
                  CustomTextField(controller: _passwordController, label: 'Пароль', required: true, obscure: true),
                  CustomTextField(controller: _brandController, label: 'Марка'),
                  CustomTextField(controller: _passportController, label: 'Паспортные данные'),
                  CustomTextField(controller: _organizationController, label: 'Организация'),

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
                          title: 'Добавить машину',
                          onTap: _submit,
                          color: const Color(0xFF00312C),
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
