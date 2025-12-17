import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'shared/services/car_service.dart';
import 'shared/services/auth_service.dart';
import 'shared/services/rental_service.dart';
import 'shared/services/repair_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CarService()),
        ChangeNotifierProvider(create: (_) => RentalService()),
        ChangeNotifierProvider(create: (_) => RepairService()),
      ],
      child: const MyApp(),
    ),
  );
}
