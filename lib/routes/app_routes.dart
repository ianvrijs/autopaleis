import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../features/home/home_screen.dart';
import '../features/login/login_screen.dart';

class AppRoutes {
  static const String initial = AppConstants.loginRoute;

  static Map<String, WidgetBuilder> routes = {
    AppConstants.loginRoute: (context) => const LoginScreen(),
    AppConstants.homeRoute: (context) => const HomeScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
}
