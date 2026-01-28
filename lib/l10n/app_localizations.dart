import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// No description provided for @automotive_companion.
  ///
  /// In en, this message translates to:
  /// **'Your automotive companion'**
  String get automotive_companion;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @please_enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get please_enter_username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get please_enter_password;

  /// Validation message for password minimum length
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters'**
  String password_min_length(int minLength);

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continue_with_github.
  ///
  /// In en, this message translates to:
  /// **'Continue with GitHub'**
  String get continue_with_github;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @whats_your_email.
  ///
  /// In en, this message translates to:
  /// **'What is your email address? We\'ll send you a link within a few minutes to set a new password.'**
  String get whats_your_email;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @please_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get please_enter_email;

  /// No description provided for @please_enter_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get please_enter_valid_email;

  /// No description provided for @password_reset_sent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get password_reset_sent;

  /// No description provided for @password_reset_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email. Please try again.'**
  String get password_reset_failed;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get login_failed;

  /// No description provided for @github_login_failed.
  ///
  /// In en, this message translates to:
  /// **'GitHub login failed'**
  String get github_login_failed;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @my_rentals.
  ///
  /// In en, this message translates to:
  /// **'My Rentals'**
  String get my_rentals;

  /// No description provided for @favorite_cars.
  ///
  /// In en, this message translates to:
  /// **'Favorite Cars'**
  String get favorite_cars;

  /// No description provided for @account_details.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get account_details;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get choose_language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation;

  /// No description provided for @no_access.
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get no_access;

  /// No description provided for @admin_panel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get admin_panel;

  /// No description provided for @rentals.
  ///
  /// In en, this message translates to:
  /// **'Rentals'**
  String get rentals;

  /// No description provided for @repairs.
  ///
  /// In en, this message translates to:
  /// **'Repairs'**
  String get repairs;

  /// No description provided for @damage_reports.
  ///
  /// In en, this message translates to:
  /// **'Damage Reports'**
  String get damage_reports;

  /// No description provided for @all_rentals.
  ///
  /// In en, this message translates to:
  /// **'All Rentals'**
  String get all_rentals;

  /// No description provided for @rental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get rental;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @from_date_to_date.
  ///
  /// In en, this message translates to:
  /// **'From {fromDate} to {toDate}'**
  String from_date_to_date(String fromDate, String toDate);

  /// No description provided for @repairs_overview.
  ///
  /// In en, this message translates to:
  /// **'Repairs Overview'**
  String get repairs_overview;

  /// No description provided for @no_repairs_found.
  ///
  /// In en, this message translates to:
  /// **'No repairs found'**
  String get no_repairs_found;

  /// No description provided for @license_plate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get license_plate;

  /// No description provided for @mechanic.
  ///
  /// In en, this message translates to:
  /// **'Mechanic'**
  String get mechanic;

  /// No description provided for @not_assigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get not_assigned;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @status_planned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get status_planned;

  /// No description provided for @status_doing.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get status_doing;

  /// No description provided for @status_done.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get status_done;

  /// No description provided for @status_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get status_unknown;

  /// No description provided for @status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get status_cancelled;

  /// No description provided for @car_details.
  ///
  /// In en, this message translates to:
  /// **'Car Details'**
  String get car_details;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @fuel_type.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuel_type;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seats;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @body_type.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get body_type;

  /// No description provided for @engine_size.
  ///
  /// In en, this message translates to:
  /// **'Engine Size'**
  String get engine_size;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @price_per_day.
  ///
  /// In en, this message translates to:
  /// **'€{price}/day'**
  String price_per_day(String price);

  /// No description provided for @book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get book_now;

  /// No description provided for @recent_reviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get recent_reviews;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @load_more_reviews.
  ///
  /// In en, this message translates to:
  /// **'Load more reviews'**
  String get load_more_reviews;

  /// No description provided for @write_review.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get write_review;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @error_loading_favorites.
  ///
  /// In en, this message translates to:
  /// **'Error loading favorites: {error}'**
  String error_loading_favorites(String error);

  /// No description provided for @no_favorites_yet.
  ///
  /// In en, this message translates to:
  /// **'You have no favorite cars yet.'**
  String get no_favorites_yet;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AutoPaleis'**
  String get welcome_message;

  /// No description provided for @search_cars_hint.
  ///
  /// In en, this message translates to:
  /// **'Search cars...'**
  String get search_cars_hint;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @body_type_label.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get body_type_label;

  /// No description provided for @fuel_type_label.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuel_type_label;

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clear_all;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sort_by;

  /// No description provided for @price_low_high.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get price_low_high;

  /// No description provided for @price_high_low.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get price_high_low;

  /// No description provided for @brand_a_z.
  ///
  /// In en, this message translates to:
  /// **'Brand: A to Z'**
  String get brand_a_z;

  /// No description provided for @brand_z_a.
  ///
  /// In en, this message translates to:
  /// **'Brand: Z to A'**
  String get brand_z_a;

  /// No description provided for @year_newest.
  ///
  /// In en, this message translates to:
  /// **'Model Year: Newest First'**
  String get year_newest;

  /// No description provided for @year_oldest.
  ///
  /// In en, this message translates to:
  /// **'Model Year: Oldest First'**
  String get year_oldest;

  /// No description provided for @number_seats.
  ///
  /// In en, this message translates to:
  /// **'Number of Seats'**
  String get number_seats;

  /// No description provided for @clear_sort.
  ///
  /// In en, this message translates to:
  /// **'Clear Sort'**
  String get clear_sort;

  /// No description provided for @no_cars_available.
  ///
  /// In en, this message translates to:
  /// **'No cars available'**
  String get no_cars_available;

  /// No description provided for @no_cars_match.
  ///
  /// In en, this message translates to:
  /// **'No cars match your filters'**
  String get no_cars_match;

  /// No description provided for @my_reviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get my_reviews;

  /// No description provided for @search_rentals_hint.
  ///
  /// In en, this message translates to:
  /// **'Search your rentals...'**
  String get search_rentals_hint;

  /// No description provided for @report_damage.
  ///
  /// In en, this message translates to:
  /// **'Report Damage'**
  String get report_damage;

  /// No description provided for @rental_details.
  ///
  /// In en, this message translates to:
  /// **'Rental Details'**
  String get rental_details;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @customer_nr.
  ///
  /// In en, this message translates to:
  /// **'Customer No'**
  String get customer_nr;

  /// No description provided for @customer_since.
  ///
  /// In en, this message translates to:
  /// **'Customer since'**
  String get customer_since;

  /// No description provided for @inspections.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get inspections;

  /// No description provided for @inspection_code.
  ///
  /// In en, this message translates to:
  /// **'Inspection Code'**
  String get inspection_code;

  /// No description provided for @odometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometer;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @description_missing.
  ///
  /// In en, this message translates to:
  /// **'Description is missing'**
  String get description_missing;

  /// No description provided for @damage_reported_success.
  ///
  /// In en, this message translates to:
  /// **'Damage reported successfully'**
  String get damage_reported_success;

  /// No description provided for @damage_report_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit damage: {error}'**
  String damage_report_failed(String error);

  /// No description provided for @rental_info.
  ///
  /// In en, this message translates to:
  /// **'Rental Information'**
  String get rental_info;

  /// No description provided for @rental_period.
  ///
  /// In en, this message translates to:
  /// **'Rental Period'**
  String get rental_period;

  /// No description provided for @damage_description.
  ///
  /// In en, this message translates to:
  /// **'Damage Description'**
  String get damage_description;

  /// No description provided for @describe_damage_hint.
  ///
  /// In en, this message translates to:
  /// **'Describe the damage in detail...'**
  String get describe_damage_hint;

  /// No description provided for @submit_damage.
  ///
  /// In en, this message translates to:
  /// **'Submit Damage'**
  String get submit_damage;

  /// No description provided for @search_reviews_hint.
  ///
  /// In en, this message translates to:
  /// **'Search reviews...'**
  String get search_reviews_hint;

  /// No description provided for @no_user_data.
  ///
  /// In en, this message translates to:
  /// **'No user data available'**
  String get no_user_data;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @not_set.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get not_set;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @profile_updated_success.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_success;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @enter_first_name.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enter_first_name;

  /// No description provided for @enter_last_name.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get enter_last_name;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
