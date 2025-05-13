import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../bloc/number_checker_cubit.dart';
import '../widgets/left_side_bar.dart';

class NumberCheckerPage extends StatefulWidget {
  const NumberCheckerPage({Key? key}) : super(key: key);

  @override
  State<NumberCheckerPage> createState() => _NumberCheckerPageState();
}

class _NumberCheckerPageState extends State<NumberCheckerPage> {
  late Timer _timer;
  late DateTime _now;

  // Поля для ввода номера и фокус
  List<TextEditingController> _controllers = List.generate(8, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(8, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controllers.forEach((controller) => controller.dispose()); // Освобождаем контроллеры
    _focusNodes.forEach((focusNode) => focusNode.dispose()); // Освобождаем FocusNodes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Левый сайдбар
          const LeftSidebar(),

          // Основной контент
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Регистрационный знак транспортного средства',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Типы РЗ
                  Row(
                    children: [
                      _buildRZButton('Гражданские РЗ', true),
                      const SizedBox(width: 8),
                      _buildRZButton('Военные РЗ', false),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Поля ввода по символам
                  Row(
                    children: List.generate(8, (index) {
                      return _buildTextField(index);
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Кнопка "Проверить"
                  BlocConsumer<NumberCheckerCubit, NumberCheckerState>(
                    listener: (context, state) {
                      // Отображаем результат в зависимости от состояния
                      if (state is NumberExists) {
                        // Например, показываем диалоговое окно или сообщение
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Номер найден'),
                              content: Text('Персона: ${state.person.name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Закрыть'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (state is NumberNotExists) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text('Номер не найден'),
                              content: Text('Такого номера не существует.'),
                            );
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is NumberCheckerLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          // Собираем номер из всех полей
                          final number = _controllers.map((controller) => controller.text).join('');
                          context.read<NumberCheckerCubit>().checkNumber(number);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Проверить'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRZButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00312C) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 48,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (text) {
          // Переходим к следующему полю при вводе текста
          if (text.isNotEmpty && index < 7) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
          // Переходим к предыдущему полю при удалении текста
          if (text.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
