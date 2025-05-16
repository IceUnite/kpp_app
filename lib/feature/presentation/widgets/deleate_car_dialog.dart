import 'package:flutter/material.dart';
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

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Реальный API-запрос на удаление машины
      await Future.delayed(const Duration(seconds: 2)); // Заглушка

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Машина удалена'), backgroundColor: Color(0xFF00312C)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                  Expanded(
                    child: EmptyButton(
                      title: 'Отмена',
                      onTap: _isLoading ? null : () => Navigator.of(context).pop(),
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : EmptyButton(title: 'Удалить машину', onTap: _submit, color: Colors.red.shade700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
