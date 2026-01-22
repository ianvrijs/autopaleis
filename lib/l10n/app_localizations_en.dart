// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get automotive_companion => 'Your automotive companion';

  @override
  String get username => 'Username';

  @override
  String get please_enter_username => 'Please enter your username';

  @override
  String get password => 'Password';

  @override
  String get please_enter_password => 'Please enter your password';

  @override
  String password_min_length(int minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String get login => 'Login';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get or => 'OR';

  @override
  String get continue_with_github => 'Continue with GitHub';

  @override
  String get reset_password => 'Reset Password';

  @override
  String get whats_your_email =>
      'What is your email address? We\'ll send you a link within a few minutes to set a new password.';

  @override
  String get email_address => 'Email Address';

  @override
  String get cancel => 'Cancel';

  @override
  String get send => 'Send';

  @override
  String get please_enter_email => 'Please enter your email address';

  @override
  String get please_enter_valid_email => 'Please enter a valid email address';

  @override
  String get password_reset_sent =>
      'Password reset email sent! Check your inbox.';

  @override
  String get password_reset_failed =>
      'Failed to send reset email. Please try again.';

  @override
  String get login_failed => 'Login failed';

  @override
  String get github_login_failed => 'GitHub login failed';

  @override
  String get my_profile => 'My Profile';

  @override
  String get my_rentals => 'My Rentals';

  @override
  String get favorite_cars => 'Favorite Cars';

  @override
  String get account_details => 'Account Details';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get choose_language => 'Choose a language';

  @override
  String get english => 'English';

  @override
  String get dutch => 'Dutch';

  @override
  String get logout_confirmation => 'Are you sure you want to logout?';

  @override
  String get no_access => 'No access';

  @override
  String get admin_panel => 'Admin Panel';

  @override
  String get rentals => 'Rentals';

  @override
  String get repairs => 'Repairs';

  @override
  String get damage_reports => 'Damage Reports';

  @override
  String get all_rentals => 'All Rentals';

  @override
  String get rental => 'Rental';

  @override
  String get status => 'Status';

  @override
  String from_date_to_date(String fromDate, String toDate) {
    return 'From $fromDate to $toDate';
  }

  @override
  String get repairs_overview => 'Repairs Overview';

  @override
  String get no_repairs_found => 'No repairs found';

  @override
  String get license_plate => 'License Plate';

  @override
  String get mechanic => 'Mechanic';

  @override
  String get not_assigned => 'Not assigned';

  @override
  String get completed => 'Completed';

  @override
  String get status_planned => 'Planned';

  @override
  String get status_doing => 'In Progress';

  @override
  String get status_done => 'Completed';

  @override
  String get status_unknown => 'Unknown';

  @override
  String get status_cancelled => 'Cancelled';

  @override
  String get car_details => 'Car Details';

  @override
  String get overview => 'Overview';

  @override
  String get year => 'Year';

  @override
  String get options => 'Options';

  @override
  String get fuel_type => 'Fuel Type';

  @override
  String get seats => 'Seats';

  @override
  String get features => 'Features';

  @override
  String get body_type => 'Body Type';

  @override
  String get engine_size => 'Engine Size';

  @override
  String get price => 'Price';

  @override
  String price_per_day(String price) {
    return '€$price/day';
  }

  @override
  String get book_now => 'Book Now';

  @override
  String get recent_reviews => 'Recent Reviews';

  @override
  String get rating => 'Rating';

  @override
  String get load_more_reviews => 'Load more reviews';

  @override
  String get write_review => 'Write a review';

  @override
  String get na => 'N/A';

  @override
  String error_loading_favorites(String error) {
    return 'Error loading favorites: $error';
  }

  @override
  String get no_favorites_yet => 'You have no favorite cars yet.';

  @override
  String get home_title => 'Home';

  @override
  String get welcome_message => 'Welcome to AutoPaleis';

  @override
  String get search_cars_hint => 'Search cars...';

  @override
  String get filters => 'Filters';

  @override
  String get sort => 'Sort';

  @override
  String get body_type_label => 'Body Type';

  @override
  String get fuel_type_label => 'Fuel Type';

  @override
  String get clear_all => 'Clear All';

  @override
  String get apply => 'Apply';

  @override
  String get sort_by => 'Sort By';

  @override
  String get price_low_high => 'Price: Low to High';

  @override
  String get price_high_low => 'Price: High to Low';

  @override
  String get brand_a_z => 'Brand: A to Z';

  @override
  String get brand_z_a => 'Brand: Z to A';

  @override
  String get year_newest => 'Model Year: Newest First';

  @override
  String get year_oldest => 'Model Year: Oldest First';

  @override
  String get number_seats => 'Number of Seats';

  @override
  String get clear_sort => 'Clear Sort';

  @override
  String get no_cars_available => 'No cars available';

  @override
  String get no_cars_match => 'No cars match your filters';

  @override
  String get my_reviews => 'My Reviews';

  @override
  String get search_rentals_hint => 'Search your rentals...';

  @override
  String get report_damage => 'Report Damage';

  @override
  String get rental_details => 'Rental Details';

  @override
  String get car => 'Car';

  @override
  String get brand => 'Brand';

  @override
  String get model => 'Model';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get customer => 'Customer';

  @override
  String get name => 'Name';

  @override
  String get customer_nr => 'Customer No';

  @override
  String get customer_since => 'Customer since';

  @override
  String get inspections => 'Inspections';

  @override
  String get inspection_code => 'Inspection Code';

  @override
  String get odometer => 'Odometer';

  @override
  String get result => 'Result';

  @override
  String get description => 'Description';

  @override
  String get description_missing => 'Description is missing';

  @override
  String get damage_reported_success => 'Damage reported successfully';

  @override
  String damage_report_failed(String error) {
    return 'Failed to submit damage: $error';
  }

  @override
  String get rental_info => 'Rental Information';

  @override
  String get rental_period => 'Rental Period';

  @override
  String get damage_description => 'Damage Description';

  @override
  String get describe_damage_hint => 'Describe the damage in detail...';

  @override
  String get submit_damage => 'Submit Damage';

  @override
  String get search_reviews_hint => 'Search reviews...';

  @override
  String get no_user_data => 'No user data available';

  @override
  String get first_name => 'First Name';

  @override
  String get last_name => 'Last Name';

  @override
  String get not_set => 'Not set';

  @override
  String get edit_profile => 'Edit Profile';

  @override
  String get profile_updated_success => 'Profile updated successfully';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get enter_first_name => 'Enter first name';

  @override
  String get enter_last_name => 'Enter last name';
}
