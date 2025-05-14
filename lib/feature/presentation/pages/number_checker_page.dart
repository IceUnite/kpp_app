import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_checker_cubit.dart';
import '../widgets/check_result.dart';
import '../widgets/left_side_bar.dart';
import '../widgets/number_car_field.dart';
import '../widgets/region_field.dart';
import '../widgets/top_bar_navigation.dart';

enum CheckerStep { initial, input, result, confirmed }

class NumberCheckerPage extends StatefulWidget {
  const NumberCheckerPage({Key? key}) : super(key: key);

  @override
  State<NumberCheckerPage> createState() => _NumberCheckerPageState();
}

class _NumberCheckerPageState extends State<NumberCheckerPage> {
  bool _isCivil = true;
  CheckerStep _step = CheckerStep.initial;
  bool _isEntry = true;
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];
  final _regionController = TextEditingController();
  final _regionFocus = FocusNode();
  Timer? _confirmTimer;

  // Переменная для хранения текущей выбранной вкладки
  String _selectedTab = 'home'; // 'home' или 'history'

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _disposeFields(); // Очистим предыдущие
    final length = 6;
    _controllers = List.generate(length, (_) => TextEditingController());
    _focusNodes = List.generate(length, (_) => FocusNode());
  }

  void _disposeFields() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
  }

  @override
  void dispose() {
    _confirmTimer?.cancel();
    _disposeFields();
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

  // Метод для изменения вкладки
  void _changeTab(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const LeftSidebar(), // Левую панель оставляем неизменной
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Передаем состояние выбранной вкладки в TopBarWithNavigation
                  TopBarWithNavigation(selectedTab: _selectedTab, onTabChanged: _changeTab),
                  const SizedBox(height: 16),
                  // Отображаем содержимое в зависимости от выбранной вкладки
                  if (_selectedTab == 'home') ...[
                    // Когда выбрана вкладка "Домик", показываем весь контент
                    if (_step == CheckerStep.initial)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _entryExitButton(
                            label: 'Заезд',
                            color: const Color(0xFF00312C),
                            onTap:
                                () => setState(() {
                                  _step = CheckerStep.input;
                                  _isEntry = true;
                                }),
                          ),
                          const SizedBox(width: 20),
                          _entryExitButton(
                            label: 'Выезд',
                            color: const Color(0xFFF37B7B),
                            onTap:
                                () => setState(() {
                                  _step = CheckerStep.input;
                                  _isEntry = false;
                                }),
                          ),
                        ],
                      )
                    else if (_step == CheckerStep.input || _step == CheckerStep.result)
                      // Здесь ваш код для блока, когда выбран шаг "input" или "result"
                      BlocBuilder<NumberCheckerCubit, NumberCheckerState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildNumberInputField(),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 180,
                                    child: RegionField(controller: _regionController, focusNode: _regionFocus),
                                  ),
                                  const SizedBox(width: 20),
                                  if (_step == CheckerStep.input ||
                                      state is NumberCheckerLoading ||
                                      state is NumberNotExists)
                                    Expanded(
                                      child: ElevatedButton(
                                        style: _buttonStyle(const Color(0xFF00312C)),
                                        onPressed: () {
                                          final number =
                                              _controllers.map((c) => c.text).join('') + _regionController.text;
                                          context.read<NumberCheckerCubit>().checkNumber(number);
                                          setState(() => _step = CheckerStep.result);
                                        },
                                        child:
                                            state is NumberCheckerLoading
                                                ? const CircularProgressIndicator(color: Colors.white)
                                                : const Text(
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
                                      style: _buttonStyle(const Color(0xFFF37B7B)),
                                      onPressed: () {
                                        _reset();
                                        context.read<NumberCheckerCubit>().reset();
                                      },
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
                              const SizedBox(height: 16),
                              if (state is NumberExists || state is NumberNotExists) ...[
                                CheckResult(state: state),
                                if (state is NumberExists)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: _buttonStyle(const Color(0xFF00312C)),
                                          onPressed: () async {
                                            final carId = state.person.id ?? 0;
                                            if (_isEntry) {
                                              await context.read<NumberCheckerCubit>().admitCar(carId);
                                            } else {
                                              await context.read<NumberCheckerCubit>().exitCar(carId);
                                            }
                                            context.read<NumberCheckerCubit>().reset();
                                            setState(() => _step = CheckerStep.confirmed);

                                            _confirmTimer = Timer(const Duration(seconds: 3), () {
                                              if (mounted) {
                                                _reset();
                                              }
                                            });
                                          },
                                          child: Text(
                                            _isEntry ? 'Подтвердить въезд' : 'Подтвердить выезд',
                                            style: const TextStyle(
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
                                          style: _buttonStyle(const Color(0xFFF37B7B)),
                                          onPressed: () {
                                            _reset();
                                            context.read<NumberCheckerCubit>().reset();
                                          },
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
                          );
                        },
                      )
                    else if (_step == CheckerStep.confirmed) ...[
                      const SizedBox(height: 32),
                      const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 16),
                      const Center(child: Text('Операция завершена')),
                      const SizedBox(height: 16),
                    ],
                  ] else ...[
                    // Когда выбрана вкладка "Документ", показываем только верхнюю панель
                    const SizedBox(height: 16),
                    const Center(child: Text('Здесь только панель навигации')),
                  ],
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
  Widget _entryExitButton({required String label, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide(color: color),
          minimumSize: const Size(100, 100),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      side: BorderSide(color: color),
      minimumSize: const Size(100, 120),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildNumberInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          _controllers.length,
          (index) => NumberCarField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            isLetter: _isCivil ? (index == 0 || index == 4 || index == 5) : (index == 4 || index == 5),
            index: index,
            controllers: _controllers,
            focusNodes: _focusNodes,
          ),
        ),
      ),
    );
  }
}
