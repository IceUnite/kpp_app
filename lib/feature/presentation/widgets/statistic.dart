import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/historia_state.dart';
import '../bloc/historiya_cubit.dart';

class StatisticsTable extends StatelessWidget {
  const StatisticsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HistoriaCubit>().state;

    if (state is HistoriaLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HistoriaError) {
      return Center(child: Text('Ошибка: ${state.message}'));
    }

    if (state is! HistoriaLoaded || state.report.report.isEmpty) {
      return const Center(child: Text('Нет данных'));
    }

    final items = state.report.report;

    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade500, width: 1.5),
        color: Colors.grey.shade100,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок таблицы
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade500, width: 1.5)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: const [
                SizedBox(width: 12),
                SizedBox(width: 30, child: Center(child: Text('№', style: TextStyle(fontWeight: FontWeight.bold)))),
                VerticalDividerWidget(),
                Expanded(child: Center(child: Text('Дата', style: TextStyle(fontWeight: FontWeight.bold)))),
                VerticalDividerWidget(),
                Expanded(child: Center(child: Text('Время', style: TextStyle(fontWeight: FontWeight.bold)))),
                VerticalDividerWidget(),
                Expanded(child: Center(child: Text('Номер', style: TextStyle(fontWeight: FontWeight.bold)))),
                VerticalDividerWidget(),
                Expanded(child: Center(child: Text('ФИО', style: TextStyle(fontWeight: FontWeight.bold)))),
                VerticalDividerWidget(),
                Expanded(child: Center(child: Text('Статус', style: TextStyle(fontWeight: FontWeight.bold)))),
                SizedBox(width: 12),
              ],
            ),
          ),

          // Список данных с разделителями
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];

                String rawDate = item.date ?? '';
                String onlyDate = '';
                String onlyTime = '';

                if (rawDate.contains(' ')) {
                  final parts = rawDate.split(' ');
                  onlyDate = parts[1];   // В исходных данных формат "HH:mm:ss dd.MM.yyyy", дата во 2-й части
                  onlyTime = parts[0];   // Время — в 1-й части
                } else {
                  onlyDate = rawDate;
                }

                final isEven = index % 2 == 0;
                final bgColor = isEven ? Colors.white : Colors.grey.shade50;

                return Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 2, offset: const Offset(0, 1))],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      SizedBox(width: 30, child: Center(child: Text('${index + 1}'))),
                      const VerticalDividerWidget(),
                      Expanded(child: Center(child: Text(onlyDate))),
                      const VerticalDividerWidget(),
                      Expanded(child: Center(child: Text(onlyTime))),
                      const VerticalDividerWidget(),
                      Expanded(child: Center(child: Text(item.plateNumber ?? ''))),
                      const VerticalDividerWidget(),
                      Expanded(child: Center(child: Text(item.fio ?? ''))),
                      const VerticalDividerWidget(),
                      Expanded(child: Center(child: Text(item.status ?? ''))),
                      const SizedBox(width: 12),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: Colors.grey.shade400,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
