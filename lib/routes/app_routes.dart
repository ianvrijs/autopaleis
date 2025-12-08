import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../features/home/home_screen.dart';
import '../features/login/login_screen.dart';
import '../features/reviews/my_reviews.dart';
import '../features/rentals/my_rentals.dart';

class AppRoutes {
  static const String initial = AppConstants.loginRoute;

  static Map<String, WidgetBuilder> routes = {
    AppConstants.loginRoute: (context) => const LoginScreen(),
    AppConstants.homeRoute: (context) => const Home(),
    AppConstants.myReviewsRoute: (context) => const MyReviewsPage(),
    AppConstants.myRentalsRoute: (context) => const MyRentalsPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const Home());
      case AppConstants.myReviewsRoute:
        return MaterialPageRoute(builder: (_) => const MyReviewsPage());
      case AppConstants.myRentalsRoute:
        return MaterialPageRoute(builder: (_) => const MyRentalsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
}
