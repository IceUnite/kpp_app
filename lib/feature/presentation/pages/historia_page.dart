import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/historiya_cubit.dart';
import '../bloc/number_checker_cubit.dart';
import '../widgets/logo_section.dart';
import '../widgets/statistic.dart';
import '../widgets/top_bar_navigation.dart';

class HistoriaPage extends StatefulWidget {
  const HistoriaPage({super.key});

  @override
  State<HistoriaPage> createState() => _HistoriaPageState();
}

class _HistoriaPageState extends State<HistoriaPage> {
  @override
  void initState() {
    super.initState();

    final String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoriaCubit>().getReport(startDate: startDate);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(  // Убрали SizedBox с height: 300
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    const LogoSection(),
                    const SizedBox(width: 16),
                    Expanded(child: TopBarWithNavigation(title: 'История заездов и выездов',)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StatisticsTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
