import 'package:flutter/material.dart';
import 'custom_textfield.dart';
import 'empty_button.dart'; // Импортируй свой кастомный виджет

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

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Реальный API-запрос
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Машина добавлена')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Expanded(
                    child: EmptyButton(
                      title: 'Отмена',
                      onTap: _isLoading ? null : () => Navigator.of(context).pop(),
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _isLoading
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
  }

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
}
