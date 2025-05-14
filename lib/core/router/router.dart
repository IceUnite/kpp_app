import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpp_app/core/router/route_path.dart';

import '../../feature/presentation/pages/number_checker_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.homePagePath,
      name: 'home',
      pageBuilder: (context, state) => _noTransitionPage(const NumberCheckerPage()),
    ),
    // GoRoute(
    //   path: RoutePath.historiaPagePath,
    //   name: 'history',
    //   pageBuilder: (context, state) => _noTransitionPage(const HistoriaPage()),
    // ),
  ],
);

/// Возвращает страницу без анимации
CustomTransitionPage _noTransitionPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // ❌ Без анимации
    },
  );
}
