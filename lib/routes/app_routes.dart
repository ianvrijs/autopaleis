import 'package:autopaleis/features/booking/booking_screen.dart';
import 'package:autopaleis/features/register/register_screen.dart';
import 'package:autopaleis/features/ride/active_ride_screen.dart';
import 'package:autopaleis/features/userInfo/userInfo.dart';
import 'package:autopaleis/features/userInfo/edit_user_info.dart';
import 'package:autopaleis/features/cars/car_details.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../features/home/home_screen.dart';
import '../features/login/login_screen.dart';
import '../features/reviews/my_reviews.dart';
import '../features/rentals/my_rentals.dart';
import '../features/rentals/rental_details_page.dart';
import '../features/profile/profile.dart';
import '../features/admin/admin_dashboard.dart';
import '../features/admin/rentals/admin_rentals_page.dart';
import '../features/admin/repairs/admin_repairs_page.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/admin/damages/admin_damages_page.dart';
//import '../features/admin/damages/admin_damages_page.dart';


class AppRoutes {
  static const String initial = AppConstants.loginRoute;

  static Map<String, WidgetBuilder> routes = {
    AppConstants.loginRoute: (context) => const LoginScreen(),
    AppConstants.registerRoute: (context) => const RegisterScreen(),
    AppConstants.homeRoute: (context) => const Home(),
    AppConstants.myReviewsRoute: (context) => const MyReviewsPage(),
    AppConstants.myRentalsRoute: (context) => const MyRentalsPage(),
   // AppConstants.rentalDetailsRoute: (context) => const RentalDetailsPage(),
    AppConstants.profileRoute: (context) => const Profile(),
    AppConstants.userInfoRoute: (context) => const UserInfo(),
    AppConstants.editUserInfoRoute: (context) => const EditUserInfo(),
    AppConstants.adminDashboardRoute: (context) => const AdminDashboard(),
    AppConstants.adminRentalsRoute: (context) => const AdminRentalsPage(),
    AppConstants.adminDamagesRoute: (_) => const AdminDamagesPage(),
    AppConstants.adminRepairsRoute: (_) => const AdminRepairsPage(),
    AppConstants.favoritesRoute: (context) => const FavoritesScreen(),
    AppConstants.bookingRoute: (context) => const BookingScreen(),
    AppConstants.activeRideRoute: (context) => const ActiveRideScreen(),
    // '/admin/damages': (_) => const AdminDamagesPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppConstants.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const Home());
      case AppConstants.myReviewsRoute:
        return MaterialPageRoute(builder: (_) => const MyReviewsPage());
      case AppConstants.myRentalsRoute:
        return MaterialPageRoute(builder: (_) => const MyRentalsPage());
      case AppConstants.rentalDetailsRoute:
      final rentalId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => RentalDetailsPage(rentalId: rentalId),
      );
      case AppConstants.profileRoute:
        return MaterialPageRoute(builder: (_) => const Profile());
      case AppConstants.userInfoRoute:
        return MaterialPageRoute(builder: (_) => const UserInfo());
      case AppConstants.editUserInfoRoute:
        return MaterialPageRoute(builder: (_) => const EditUserInfo());
      case AppConstants.favoritesRoute:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case AppConstants.bookingRoute:
        return MaterialPageRoute(builder: (_) => const BookingScreen());
      case AppConstants.activeRideRoute:
        return MaterialPageRoute(builder: (_) => const ActiveRideScreen());
      case AppConstants.carDetailsRoute:
        if (settings.arguments is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => CarDetails(car: settings.arguments as Map<String, dynamic>),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Car details not available')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
}
