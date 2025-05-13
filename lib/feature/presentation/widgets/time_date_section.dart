import 'package:flutter/material.dart';
import 'dart:async'; // Для работы с таймером

class TimeAndDateSection extends StatefulWidget {
  final String initialTime;
  final String initialDate;
  final String initialDay;

  const TimeAndDateSection({
    Key? key,
    required this.initialTime,
    required this.initialDate,
    required this.initialDay,
  }) : super(key: key);

  @override
  _TimeAndDateSectionState createState() => _TimeAndDateSectionState();
}

class _TimeAndDateSectionState extends State<TimeAndDateSection> {
  late Timer _timer;
  late String _time;
  late String _date;
  late String _day;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime;
    _date = widget.initialDate;
    _day = widget.initialDay;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time = _formatTime(now);
      _date = _formatDate(now);
      _day = _formatDay(now);
    });
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
  }

  String _formatDay(DateTime dateTime) {
    const daysOfWeek = [
      'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'
    ];
    return daysOfWeek[dateTime.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _time,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_date\n$_day',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
