import 'package:autopaleis/shared/models/ride_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'shared/services/car_service.dart';
import 'shared/services/auth_service.dart';
import 'shared/services/rental_service.dart';
import 'shared/services/repair_service.dart';
import 'shared/services/favorites_service.dart';
import 'shared/services/locale_service.dart';
import 'shared/services/reviews_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CarService()),
        ChangeNotifierProvider(create: (_) => RentalService()),
        ChangeNotifierProvider(create: (_) => RepairService()),
        ChangeNotifierProvider(create: (_) => FavoritesService()),
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => Ride()),
        ChangeNotifierProvider(create: (_) => ReviewsService()..loadReviews()),
      ],
      child: const MyApp(),
    ),
  );
}
