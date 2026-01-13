class AppConstants {
  // App Strings
  static const String appTitle = 'AutoPaleis';
  static const String welcomeMessage = 'Welcome to AutoPaleis';
  static const String loginTitle = 'Login';
  static const String homeTitle = 'Home';

  // Navigation
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String myReviewsRoute = '/my_reviews';
  static const String myRentalsRoute = '/my_rentals';
  static const String rentalDetailsRoute = '/rental-details';
  static const String reportDamageRoute = '/report_damage';
  static const String profileRoute = '/profile';
  static const String userInfoRoute = '/userInfo';
  static const String editUserInfoRoute = '/edit_user_info';
  static const String carDetailsRoute = '/car_details';
  static const String favoritesRoute = '/favorites';

  // Admin
  static const String adminDashboardRoute = '/admin';
  static const String adminRentalsRoute = '/admin/rentals';
  static const String adminRepairsRoute = '/admin/repairs';

  // Validation
  static const int minPasswordLength = 4;
  static const int maxUsernameLength = 50;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}
