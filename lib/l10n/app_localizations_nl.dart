// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get automotive_companion => 'Your automotive companion';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get please_enter_username => 'Voer alstublieft uw gebruikersnaam in';

  @override
  String get password => 'Wachtwoord';

  @override
  String get please_enter_password => 'Voer alstublieft uw wachtwoord in';

  @override
  String password_min_length(int minLength) {
    return 'Wachtwoord moet minstens $minLength karakters lang zijn';
  }

  @override
  String get login => 'Inloggen';

  @override
  String get forgot_password => 'Wachtwoord Vergeten?';

  @override
  String get or => 'OF';

  @override
  String get continue_with_github => 'Doorgaan met GitHub';

  @override
  String get reset_password => 'Wachtwoord Opnieuw Instellen';

  @override
  String get whats_your_email =>
      'Wat is je e-mailadres? Dan zenden we je binnen enkele minuten een linkje om een nieuw wachtwoord in te stellen.';

  @override
  String get email_address => 'E-mailadres';

  @override
  String get cancel => 'Annuleren';

  @override
  String get send => 'Verzenden';

  @override
  String get please_enter_email => 'Voer uw e-mailadres in';

  @override
  String get please_enter_valid_email => 'Voer een geldig e-mailadres in';

  @override
  String get password_reset_sent =>
      'E-mail voor wachtwoordherstel verzonden! Controleer uw inbox.';

  @override
  String get password_reset_failed =>
      'Het verzenden van de herstel-e-mail is mislukt. Probeer het opnieuw.';

  @override
  String get login_failed => 'Inloggen mislukt';

  @override
  String get github_login_failed => 'GitHub inloggen mislukt';

  @override
  String get my_profile => 'Mijn Profiel';

  @override
  String get my_rentals => 'Mijn Boekingen';

  @override
  String get favorite_cars => 'Favoriete Auto\'s';

  @override
  String get account_details => 'Accountgegevens';

  @override
  String get language => 'Taal';

  @override
  String get logout => 'Afmelden';

  @override
  String get choose_language => 'Kies een taal';

  @override
  String get english => 'Engels';

  @override
  String get dutch => 'Nederlands';

  @override
  String get logout_confirmation => 'Weet je zeker dat je wilt afmelden?';

  @override
  String get no_access => 'Geen toegang';

  @override
  String get admin_panel => 'Admin Paneel';

  @override
  String get rentals => 'Rentals';

  @override
  String get repairs => 'Reparaties';

  @override
  String get damage_reports => 'Schademeldingen';

  @override
  String get all_rentals => 'Alle Rentals';

  @override
  String get rental => 'Rental';

  @override
  String get status => 'Status';

  @override
  String from_date_to_date(String fromDate, String toDate) {
    return 'Van $fromDate tot $toDate';
  }

  @override
  String get repairs_overview => 'Repairs Overzicht';

  @override
  String get no_repairs_found => 'Geen reparaties gevonden';

  @override
  String get license_plate => 'Kenteken';

  @override
  String get mechanic => 'Monteur';

  @override
  String get not_assigned => 'Niet toegewezen';

  @override
  String get completed => 'Voltooid';

  @override
  String get status_planned => 'Gepland';

  @override
  String get status_doing => 'Bezig';

  @override
  String get status_done => 'Voltooid';

  @override
  String get status_unknown => 'Onbekend';

  @override
  String get status_cancelled => 'Geannuleerd';

  @override
  String get car_details => 'Auto Details';

  @override
  String get overview => 'Overzicht';

  @override
  String get year => 'Jaar';

  @override
  String get options => 'Opties';

  @override
  String get fuel_type => 'Brandstoftype';

  @override
  String get seats => 'Zitplaatsen';

  @override
  String get features => 'Kenmerken';

  @override
  String get body_type => 'Carrosserietype';

  @override
  String get engine_size => 'Motorinhoud';

  @override
  String get price => 'Prijs';

  @override
  String price_per_day(String price) {
    return '€$price/dag';
  }

  @override
  String get book_now => 'Boek Nu';

  @override
  String get recent_reviews => 'Recente Beoordelingen';

  @override
  String get rating => 'Beoordeling';

  @override
  String get load_more_reviews => 'Meer beoordelingen laden';

  @override
  String get write_review => 'Schrijf een beoordeling';

  @override
  String get na => 'N/A';

  @override
  String error_loading_favorites(String error) {
    return 'Fout bij het laden van favorieten: $error';
  }

  @override
  String get no_favorites_yet => 'Je hebt nog geen favoriete auto\'s.';

  @override
  String get home_title => 'Home';

  @override
  String get welcome_message => 'Welkom bij AutoPaleis';

  @override
  String get search_cars_hint => 'Zoek auto\'s...';

  @override
  String get filters => 'Filters';

  @override
  String get sort => 'Sorteren';

  @override
  String get body_type_label => 'Carrosserietype';

  @override
  String get fuel_type_label => 'Brandstoftype';

  @override
  String get clear_all => 'Alles wissen';

  @override
  String get apply => 'Toepassen';

  @override
  String get sort_by => 'Sorteren op';

  @override
  String get price_low_high => 'Prijs: Laag naar Hoog';

  @override
  String get price_high_low => 'Prijs: Hoog naar Laag';

  @override
  String get brand_a_z => 'Merk: A tot Z';

  @override
  String get brand_z_a => 'Merk: Z tot A';

  @override
  String get year_newest => 'Bouwjaar: Nieuwste eerst';

  @override
  String get year_oldest => 'Bouwjaar: Oudste eerst';

  @override
  String get number_seats => 'Aantal zitplaatsen';

  @override
  String get clear_sort => 'Sortering wissen';

  @override
  String get no_cars_available => 'Geen auto\'s beschikbaar';

  @override
  String get no_cars_match => 'Geen auto\'s gevonden met deze filters';

  @override
  String get my_reviews => 'Mijn Reviews';

  @override
  String get search_rentals_hint => 'Zoek in je rentals...';

  @override
  String get report_damage => 'Schade melden';

  @override
  String get rental_details => 'Huur Details';

  @override
  String get car => 'Auto';

  @override
  String get brand => 'Merk';

  @override
  String get model => 'Model';

  @override
  String get from => 'Van';

  @override
  String get to => 'Tot';

  @override
  String get coordinates => 'Coördinaten';

  @override
  String get customer => 'Klant';

  @override
  String get name => 'Naam';

  @override
  String get customer_nr => 'Klantnr';

  @override
  String get customer_since => 'Klant sinds';

  @override
  String get inspections => 'Inspecties';

  @override
  String get inspection_code => 'Inspectie Code';

  @override
  String get odometer => 'Kilometerteller';

  @override
  String get result => 'Resultaat';

  @override
  String get description => 'Omschrijving';

  @override
  String get description_missing => 'Beschrijving is niet aanwezig';

  @override
  String get damage_reported_success => 'Schade succesvol gemeld';

  @override
  String damage_report_failed(String error) {
    return 'Kon schade niet indienen: $error';
  }

  @override
  String get rental_info => 'Huurinformatie';

  @override
  String get rental_period => 'Huurperiode';

  @override
  String get damage_description => 'Schadebeschrijving';

  @override
  String get describe_damage_hint => 'Beschrijf de schade in detail...';

  @override
  String get submit_damage => 'Schade indienen';

  @override
  String get search_reviews_hint => 'Zoek in je reviews...';

  @override
  String get no_user_data => 'Geen gebruikersgegevens beschikbaar';

  @override
  String get first_name => 'Voornaam';

  @override
  String get last_name => 'Achternaam';

  @override
  String get not_set => 'Niet ingesteld';

  @override
  String get edit_profile => 'Profiel Bewerken';

  @override
  String get profile_updated_success => 'Profiel succesvol bijgewerkt';

  @override
  String get save_changes => 'Wijzigingen Opslaan';

  @override
  String get enter_first_name => 'Voornaam invoeren';

  @override
  String get enter_last_name => 'Achternaam invoeren';
}
