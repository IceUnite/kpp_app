import 'package:flutter/material.dart';
import 'package:kpp_app/core/router/route_path.dart';
import 'package:go_router/go_router.dart';

class TopBarWithNavigation extends StatelessWidget {
  TopBarWithNavigation({super.key});

  Color getIconColor(bool isActive) => isActive ? Colors.amber : Colors.white;

  @override
  Widget build(BuildContext context) {
    final String selectedTab = GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFF00312C), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Левая кнопка: зависит от вкладки
          IconButton(
            icon: Icon(
              selectedTab == '/history' ? Icons.arrow_back : Icons.description,
              color: getIconColor(true),
              size: 32,
            ),
            onPressed: () {
              if (selectedTab == '/history') {
                context.go(RoutePath.homePagePath); // 👈 назад на главную
              } else {
                context.go(RoutePath.historiaPagePath); // 👈 переход в историю
              }
            },
          ),

          /// Центр
          const Expanded(
            child: Center(
              child: Text(
                'Регистрационный знак транспортного средства',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),

          /// Заглушка справа (чтобы текст был по центру)
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}
