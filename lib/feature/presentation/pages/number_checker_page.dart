import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool _isCivil = true;
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _initializeFields();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  void _initializeFields() {
    final length = 9; // и гражданский, и военный — 9 символов
    _controllers.forEach((c) => c.dispose());
    _focusNodes.forEach((f) => f.dispose());
    _controllers = List.generate(length, (_) => TextEditingController());
    _focusNodes = List.generate(length, (_) => FocusNode());
  }

  @override
  void dispose() {
    _timer.cancel();
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const LeftSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 82,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF00312C), borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        'Регистрационный знак транспортного средства',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildRZButton('Гражданские РЗ', _isCivil, () {
                        setState(() {
                          _isCivil = true;
                          _initializeFields();
                        });
                      }),
                      const SizedBox(width: 8),
                      _buildRZButton('Военные РЗ', !_isCivil, () {
                        setState(() {
                          _isCivil = false;
                          _initializeFields();
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(_controllers.length, (index) {
                      return _buildTextField(index);
                    }),
                  ),
                  const SizedBox(height: 16),
                  BlocConsumer<NumberCheckerCubit, NumberCheckerState>(
                    listener: (context, state) {
                      if (state is NumberExists) {
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
                          final number = _controllers.map((c) => c.text).join('');
                          context.read<NumberCheckerCubit>().checkNumber(number);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildRZButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00312C) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black26),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget _buildTextField(int index) {
    final isLetter = _isCivil
        ? [0, 4, 5].contains(index)
        : [4, 5].contains(index);

    final double fieldHeight = isLetter ? 60.0 : 80.0;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 48,
      height: fieldHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
      child: Focus(
        onKey: (FocusNode node, RawKeyEvent event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[index].text.isEmpty &&
              index > 0) {
            _controllers[index - 1].clear();
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          maxLength: 1,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.allow(
              RegExp(isLetter ? r'[А-Яа-яA-Za-z]' : r'[0-9]'),
            ),
          ],
          onChanged: (text) {
            if (text.isNotEmpty && index < _focusNodes.length - 1) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
          },
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

}
