import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Для форматирования даты и времени

import 'time_date_section.dart'; // Обновленный виджет
import 'logo_section.dart'; // Логотип
import 'empty_button.dart'; // Пустая кнопка

class LeftSidebar extends StatefulWidget {
  const LeftSidebar({Key? key}) : super(key: key);

  @override
  _LeftSidebarState createState() => _LeftSidebarState();
}

class _LeftSidebarState extends State<LeftSidebar> {
  late String _time;
  late String _date;
  late String _day;

  @override
  void initState() {
    super.initState();
    _updateTime(); // Инициализация времени при старте
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time = DateFormat('HH:mm:ss').format(now);
      _date = DateFormat('dd.MM.yyyy').format(now);
      _day = DateFormat.EEEE('ru').format(now);
    });

    // Обновление времени каждую секунду
    Future.delayed(const Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Логотип и заголовок
          const LogoSection(),

          const SizedBox(height: 24),

          // Время и дата
          TimeAndDateSection(
            initialTime: _time,
            initialDate: _date,
            initialDay: _day,
          ),

          const SizedBox(height: 16),

          // Две пустые кнопки
          const EmptyButton(),
          const SizedBox(height: 12),
          const EmptyButton(),
        ],
      ),
    );
  }
}
