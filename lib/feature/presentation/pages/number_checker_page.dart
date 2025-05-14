import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_checker_cubit.dart';
import '../widgets/check_result.dart';
import '../widgets/left_side_bar.dart';
import '../widgets/number_car_field.dart';
import '../widgets/region_field.dart';

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
                                    children: List.generate(_controllers.length, (index) => NumberCarField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      isLetter: index == 0 || index == 4 || index == 5, // как у тебя раньше было
                                      index: index,
                                      controllers: _controllers,
                                      focusNodes: _focusNodes,
                                    ),),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(width: 180, child: RegionField(
                                  controller: _regionController,
                                  focusNode: _regionFocus,
                                ),),
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
                              CheckResult(state: state),
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


}
