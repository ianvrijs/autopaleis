import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'shared/services/car_service.dart';
import 'shared/services/auth_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CarService()),
      ],
      child: const MyApp(),
    ),
  );
}
