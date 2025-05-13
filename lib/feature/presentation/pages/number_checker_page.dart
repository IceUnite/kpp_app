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

  final _mainController = TextEditingController();
  final _regionController = TextEditingController();

  final _mainFocus = FocusNode();
  final _regionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });

    _mainController.addListener(() {
      if (_mainController.text.length == 6) {
        FocusScope.of(context).requestFocus(_regionFocus);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _mainController.dispose();
    _regionController.dispose();
    _mainFocus.dispose();
    _regionFocus.dispose();
    super.dispose();
  }

  bool _validateMain(String value) {
    final civilPattern = RegExp(r'^[А-Я]{2}[0-9]{3}[А-Я]{1}$');
    final militaryPattern = RegExp(r'^[0-9]{4}[А-Я]{2}$');
    return _isCivil ? civilPattern.hasMatch(value) : militaryPattern.hasMatch(value);
  }

  bool _validateRegion(String value) => RegExp(r'^\d{3}$').hasMatch(value);

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
                    decoration: BoxDecoration(
                      color: const Color(0xFF00312C),
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                          _mainController.clear();
                          _regionController.clear();
                        });
                      }),
                      const SizedBox(width: 8),
                      _buildRZButton('Военные РЗ', !_isCivil, () {
                        setState(() {
                          _isCivil = false;
                          _mainController.clear();
                          _regionController.clear();
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildMainField()),
                      const SizedBox(width: 16),
                      SizedBox(width: 80, child: _buildRegionField()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  BlocConsumer<NumberCheckerCubit, NumberCheckerState>(
                    listener: (context, state) {
                      if (state is NumberExists) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Номер найден'),
                            content: Text('Персона: ${state.person.name}'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Закрыть'),
                              ),
                            ],
                          ),
                        );
                      } else if (state is NumberNotExists) {
                        showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                            title: Text('Номер не найден'),
                            content: Text('Такого номера не существует.'),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is NumberCheckerLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final main = _mainController.text.toUpperCase();
                          final region = _regionController.text;
                          if (_validateMain(main) && _validateRegion(region)) {
                            final fullNumber = main + region;
                            context.read<NumberCheckerCubit>().checkNumber(fullNumber);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Неверный формат номера')),
                            );
                          }
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

  Widget _buildMainField() {
    return TextField(
      controller: _mainController,
      focusNode: _mainFocus,
      maxLength: 6,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        UpperCaseTextFormatter(),
        PlateMaskFormatter(isCivil: _isCivil),
      ],
      decoration: const InputDecoration(
        labelText: 'Основной номер',
        border: OutlineInputBorder(),
        counterText: '',
      ),
    );
  }

  Widget _buildRegionField() {
    return TextField(
      controller: _regionController,
      focusNode: _regionFocus,
      maxLength: 3,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(3),
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: const InputDecoration(
        labelText: 'Регион',
        border: OutlineInputBorder(),
        counterText: '',
      ),
    );
  }
}

/// Верхний регистр
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Маска по позициям
class PlateMaskFormatter extends TextInputFormatter {
  final bool isCivil;
  PlateMaskFormatter({required this.isCivil});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.toUpperCase();
    if (newText.length > 6) return oldValue;

    for (int i = 0; i < newText.length; i++) {
      final char = newText[i];
      final isLetter = RegExp(r'[А-Я]').hasMatch(char);
      final isDigit = RegExp(r'[0-9]').hasMatch(char);

      bool valid = false;
      if (isCivil) {
        // АА111А
        valid = (i < 2 && isLetter) || (i >= 2 && i <= 4 && isDigit) || (i == 5 && isLetter);
      } else {
        // 1111АА
        valid = (i < 4 && isDigit) || (i >= 4 && isLetter);
      }

      if (!valid) return oldValue;
    }

    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}
