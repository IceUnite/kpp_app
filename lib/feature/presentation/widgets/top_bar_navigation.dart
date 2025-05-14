import 'package:flutter/material.dart';

class TopBarWithNavigation extends StatelessWidget {
  final String selectedTab; // Параметр для выбранной вкладки
  final Function(String) onTabChanged; // Функция для обработки изменения вкладки

  const TopBarWithNavigation({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  Color getIconColor(bool isActive) => isActive ? Colors.amber : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF00312C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Домик
          IconButton(
            icon: Icon(
              Icons.home,
              color: getIconColor(selectedTab == 'home'),
              size: 32,
            ),
            onPressed: () => onTabChanged('home'),
          ),

          /// Текст по центру
          const Expanded(
            child: Center(
              child: Text(
                'Регистрационный знак транспортного средства',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),

          /// Документ
          IconButton(
            icon: Icon(
              Icons.description,
              color: getIconColor(selectedTab == 'history'),
              size: 32,
            ),
            onPressed: () => onTabChanged('history'),
          ),
        ],
      ),
    );
  }
}
