import 'package:flutter/material.dart';

import './features/auth/pages/auth_page.dart';
import './features/home/pages/home_page.dart';
import './features/home/pages/new_todo_page.dart';
import './features/home/pages/todo_detail_page.dart';

import './models/todo.dart';

class Routes {
  static const String authRoute = '/auth-page';
  static const String homeRoute = '/home-page';
  static const String newTodoRoute = '/new-todo-page';
  static const String todoDetailRoute = '/todo-detail-page';
}

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case Routes.authRoute:
      return MaterialPageRoute(builder: (_) => const AuthPage());
    case Routes.homeRoute:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case Routes.newTodoRoute:
      final args = settings.arguments as Todo?;
      return MaterialPageRoute(
        builder: (_) => TodoTaskInputPage(
          todo: args,
        ),
      );
    case Routes.todoDetailRoute:
      final args = settings.arguments as Todo;
      return MaterialPageRoute(
        builder: (_) => TodoDetailPage(
          todo: args,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Center(
          child: Text('Page not found'),
        ),
      );
  }
}
