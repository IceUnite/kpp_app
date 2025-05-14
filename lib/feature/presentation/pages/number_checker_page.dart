import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_checker_cubit.dart';
import '../widgets/left_side_bar.dart';

enum CheckerStep { initial, input, result, confirmed }

class NumberCheckerPage extends StatefulWidget {
  const NumberCheckerPage({Key? key}) : super(key: key);

  @override
  State<NumberCheckerPage> createState() => _NumberCheckerPageState();
}

class _NumberCheckerPageState extends State<NumberCheckerPage> {
  CheckerStep _step = CheckerStep.initial;
  bool _isEntry = true;
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

  void _reset() {
    setState(() {
      _step = CheckerStep.initial;
      _initializeFields();
      _regionController.clear();
    });
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
                  const SizedBox(height: 16),
                  if (_step == CheckerStep.initial) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00312C),
                              side: const BorderSide(color: Color(0xFF00312C)),
                              minimumSize: const Size(100, 100),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed:
                                () => setState(() {
                                  _step = CheckerStep.input;
                                  _isEntry = true;
                                }),
                            child: const Text(
                              'Заезд',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF37B7B),
                              side: const BorderSide(color: Color(0xFF00312C)),
                              minimumSize: const Size(100, 100),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed:
                                () => setState(() {
                                  _step = CheckerStep.input;
                                  _isEntry = false;
                                }),
                            child: const Text(
                              'Выезд',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (_step == CheckerStep.input || _step == CheckerStep.result) ...[
                    BlocBuilder<NumberCheckerCubit, NumberCheckerState>(
                      builder: (context, state) {
                        _lastState = state;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                    children: List.generate(_controllers.length, (index) => _buildTextField(index)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(width: 180, child: _buildRegionField()),
                                if (_step == CheckerStep.input || state is NumberNotExists) ...[
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF7E7E7E),
                                        side: const BorderSide(color: Color(0xFF00312C)),
                                        minimumSize: const Size(100, 100),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () {
                                        final number =
                                            _controllers.map((c) => c.text).join('') + _regionController.text;
                                        context.read<NumberCheckerCubit>().checkNumber(number);
                                        setState(() => _step = CheckerStep.result);
                                      },
                                      child: const Text(
                                        'Проверить',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _reset();
                                        context.read<NumberCheckerCubit>().reset();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF37B7B),
                                        side: const BorderSide(color: Color(0xFF00312C)),
                                        minimumSize: const Size(100, 100),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: const Text(
                                        'Назад',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (state is NumberExists || state is NumberNotExists) ...[
                              _buildResultWidget(state),
                              if (state is NumberExists) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF00312C),
                                          side: const BorderSide(color: Color(0xFF00312C)),
                                          minimumSize: const Size(100, 100),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        onPressed: () async {
                                          final carId = state.person.id ?? 0;
                                          if (_isEntry) {
                                            await context.read<NumberCheckerCubit>().admitCar(carId);
                                            context.read<NumberCheckerCubit>().reset();

                                          } else {
                                            await context.read<NumberCheckerCubit>().exitCar(carId);
                                            context.read<NumberCheckerCubit>().reset();

                                          }

                                          setState(() => _step = CheckerStep.confirmed);

                                          // Через 5 секунд вернемся к начальному состоянию
                                          Future.delayed(const Duration(seconds: 3), () {
                                            if (mounted) {
                                              _reset();
                                            }
                                          });
                                        },

                                        child: Text(
                                          _isEntry ? 'Подтвердить въезд' : 'Подтвердить выезд',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _reset();
                                          context.read<NumberCheckerCubit>().reset();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF37B7B),
                                          side: const BorderSide(color: Color(0xFF00312C)),
                                          minimumSize: const Size(100, 100),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: const Text(
                                          'Назад',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ],
                        );
                      },
                    ),
                  ] else if (_step == CheckerStep.confirmed) ...[
                    const SizedBox(height: 32),
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 16),
                    const Center(child: Text('Операция завершена')), // Можно заменить на анимацию
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(int index) {
    final isLetter = [0, 4, 5].contains(index);
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
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.allow(RegExp(isLetter ? r'[А-Яа-я]' : r'[0-9]')),
          ],
          onChanged: (text) {
            if (isLetter && text.isNotEmpty) {
              final upper = text.toUpperCase();
              _controllers[index].value = TextEditingValue(
                text: upper,
                selection: TextSelection.collapsed(offset: upper.length),
              );
            }

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

  Widget _buildResultWidget(NumberCheckerState state) {
    if (state is NumberExists) {
      final person = state.person;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          border: Border.all(color: Colors.green.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
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
        ),
      );
    } else if (state is NumberNotExists) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '❌ Пользователь не найден.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade900),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
