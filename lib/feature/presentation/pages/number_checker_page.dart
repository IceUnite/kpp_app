import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_checker_cubit.dart';
import '../widgets/left_side_bar.dart';

class NumberCheckerPage extends StatefulWidget {
  const NumberCheckerPage({Key? key}) : super(key: key);

  @override
  State<NumberCheckerPage> createState() => _NumberCheckerPageState();
}

class _NumberCheckerPageState extends State<NumberCheckerPage> {
  bool _isCivil = true;
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];
  final _regionController = TextEditingController();
  final _regionFocus = FocusNode();
  NumberCheckerState? _lastState;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final length = 6;
    _controllers.forEach((c) => c.dispose());
    _focusNodes.forEach((f) => f.dispose());
    _controllers = List.generate(length, (_) => TextEditingController());
    _focusNodes = List.generate(length, (_) => FocusNode());
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    _regionController.dispose();
    _regionFocus.dispose();
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
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
                  BlocBuilder<NumberCheckerCubit, NumberCheckerState>(
                    builder: (context, state) {
                      _lastState = state;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(_controllers.length, (index) {
                                return _buildTextField(index);
                              }),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            children: [SizedBox(width: 180, child: _buildRegionField()), const SizedBox(height: 12)],
                          ),

                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<NumberCheckerCubit, NumberCheckerState>(
                    builder: (context, state) {
                      Color? backgroundColor;
                      Color? borderColor;
                      Widget resultWidget = const SizedBox.shrink();

                      if (state is NumberExists) {
                        final person = state.person;
                        backgroundColor = Colors.green.shade50;
                        borderColor = Colors.green.shade700;

                        resultWidget = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✅ Пользователь найден!',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                            ),
                            const SizedBox(height: 8),
                            Text('Фамилия: ${person.surname}'),
                            Text('Имя: ${person.name}'),
                            Text('Отчество: ${person.lastname}'),
                            Text('Номер: ${person.number}'),
                          ],
                        );
                      } else if (state is NumberNotExists) {
                        backgroundColor = Colors.red.shade50;
                        borderColor = Colors.red.shade700;

                        resultWidget = Text(
                          '❌ Пользователь не найден.',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade900),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          if (state is NumberCheckerLoading)
                            ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          else
                            ElevatedButton(
                              onPressed: () {
                                final number = _controllers.map((c) => c.text).join('') + _regionController.text;
                                context.read<NumberCheckerCubit>().checkNumber(number);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Проверить'),
                            ),
                          const SizedBox(height: 16),
                          if (backgroundColor != null && borderColor != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                border: Border.all(color: borderColor, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: resultWidget,
                            ),
                          if (state is NumberExists) ...[
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // final carId = 0;
                                      final carId = state.person.id;
                                      context.read<NumberCheckerCubit>().admitCar(carId ?? 0);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25B97B),
                                      side: const BorderSide(color: Color(0xFF00312C)),
                                      // minimumSize: const Size(double.infinity, 48),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Заехать', style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // final carId = 0;
                                      final carId = state.person.id;
                                      context.read<NumberCheckerCubit>().exitCar(carId ?? 0);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF37B7B),
                                      side: const BorderSide(color: Color(0xFF00312C)),
                                      // minimumSize: const Size(double.infinity, 48),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Выехать', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
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
    final isLetter = _isCivil ? [0, 4, 5].contains(index) : [4, 5].contains(index);
    final double height = isLetter ? 60.0 : 80.0;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 48,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
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
            FilteringTextInputFormatter.allow(RegExp(isLetter ? r'[А-Яа-яA-Za-z]' : r'[0-9]')),
          ],
          onChanged: (text) {
            if (text.isNotEmpty && index < _focusNodes.length - 1) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
          },
          decoration: const InputDecoration(counterText: '', border: InputBorder.none),
          style: const TextStyle(fontSize: 44),
        ),
      ),
    );
  }

  Widget _buildRegionField() {
    return Container(
      height: 110,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: TextField(
        controller: _regionController,
        focusNode: _regionFocus,
        maxLength: 3,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [LengthLimitingTextInputFormatter(3), FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: 'Регион',
          labelStyle: const TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
        ),
        style: const TextStyle(fontSize: 44, letterSpacing: 12),
      ),
    );
  }
}
