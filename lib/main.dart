import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './features/auth/pages/auth_page.dart';
import './features/home/pages/home_page.dart';

import './features/auth/services/auth_services.dart';

import './provider/user_provider.dart';
import './provider/todo_provider.dart';

import './common/utils/colors.dart';

import './routes.dart';

void main() async {
  await dotenv.load();
  runApp(
    const Todoist(),
  );
}

class Todoist extends StatelessWidget {
  const Todoist({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthServices authService = AuthServices();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<TodoProvider>(
          create: (_) => TodoProvider(),
        ),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userData, child) {
          return MaterialApp(
            title: 'Todoist',
            theme: Colours.customTheme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) => generateRoutes(settings),
            home: userData.isAuth
                ? const HomePage()
                : FutureBuilder(
                    future: authService.autoLogin(
                      context: context,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return const AuthPage();
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
