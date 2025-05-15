import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_checker_cubit.dart';
import '../bloc/number_checker_state.dart';

class StatisticsTable extends StatelessWidget {
  const StatisticsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NumberCheckerCubit>().state;

    // Проверяем, что состояние с загруженным отчетом и отчет не пустой
    if (state.report == null || state.report!.report.isEmpty) {
      return const Center(
        child: Text(
          'Нет данных',
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    final report = state.report!;
    final items = report.report;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.grey.shade300,
            border: Border.all(color: Colors.grey.shade500, width: 1),
          ),
          child: Row(
            children: const [
              SizedBox(width: 20),
              Expanded(child: Center(child: Text('Дата', style: TextStyle(fontWeight: FontWeight.bold)))),
              VerticalDivider(width: 1, thickness: 1),
              Expanded(child: Center(child: Text('Номер', style: TextStyle(fontWeight: FontWeight.bold)))),
              VerticalDivider(width: 1, thickness: 1),
              Expanded(child: Center(child: Text('ФИО', style: TextStyle(fontWeight: FontWeight.bold)))),
              VerticalDivider(width: 1, thickness: 1),
              Expanded(child: Center(child: Text('Статус', style: TextStyle(fontWeight: FontWeight.bold)))),
              SizedBox(width: 20),
            ],
          ),
        ),

        SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                color: Colors.white,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(child: Center(child: Text(item.date ?? ''))),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: Center(child: Text(item.plateNumber ?? ''))),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: Center(child: Text(item.fio ?? ''))),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: Center(child: Text(item.status ?? ''))),
                    const SizedBox(width: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
