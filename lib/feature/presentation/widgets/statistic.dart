import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_checker_cubit.dart';

class StatisticsTable extends StatelessWidget {
  const StatisticsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NumberCheckerCubit>().state;

    if (state.report == null || state.report!.report.isEmpty) {
      return const Center(child: Text('Нет данных'));
    }

    final items = state.report!.report;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.grey.shade300,
            border: Border.all(color: Colors.grey.shade500, width: 1),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: const [
              SizedBox(width: 20),
              Expanded(child: Center(child: Text('Дата', style: TextStyle(fontWeight: FontWeight.bold)))),
              VerticalDividerWidget(),
              Expanded(child: Center(child: Text('Время', style: TextStyle(fontWeight: FontWeight.bold)))),
              VerticalDividerWidget(),
              Expanded(child: Center(child: Text('Номер', style: TextStyle(fontWeight: FontWeight.bold)))),
              VerticalDividerWidget(),
              Expanded(child: Center(child: Text('ФИО', style: TextStyle(fontWeight: FontWeight.bold)))),
              VerticalDividerWidget(),
              Expanded(child: Center(child: Text('Статус', style: TextStyle(fontWeight: FontWeight.bold)))),
              SizedBox(width: 20),
            ],
          ),
        ),

        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];

              String rawDate = item.date ?? '';
              String onlyDate = '';
              String onlyTime = '';

              if (rawDate.contains(' ')) {
                final parts = rawDate.split(' ');
                onlyDate = parts[0];
                onlyTime = parts.length > 1 ? parts[1] : '';
              } else {
                onlyDate = rawDate;
              }

              final isEven = index % 2 == 0;
              final bgColor = isEven ? Colors.white : Colors.grey.shade200;

              return Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(child: Center(child: Text(onlyDate))),
                    const VerticalDividerWidget(),
                    Expanded(child: Center(child: Text(onlyTime))),
                    const VerticalDividerWidget(),
                    Expanded(child: Center(child: Text(item.plateNumber ?? ''))),
                    const VerticalDividerWidget(),
                    Expanded(child: Center(child: Text(item.fio ?? ''))),
                    const VerticalDividerWidget(),
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

class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey.shade500,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
