import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/models/car_model.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/favorites_service.dart';
import '../../shared/widgets/car_card.dart';
import '../../l10n/app_localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<List<CarModel>>? _favoriteCarsFuture;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCars();
  }

  void _loadFavoriteCars() {
    final favoritesService = context.read<FavoritesService>();
    final authService = context.read<AuthService>();
    setState(() {
      _favoriteCarsFuture = favoritesService.fetchFavoriteCars(authService.token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorite_cars),
      ),
      body: FutureBuilder<List<CarModel>>(
        future: _favoriteCarsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(l10n.error_loading_favorites(snapshot.error.toString())));
          }

          final favoriteCars = snapshot.data;

          if (favoriteCars == null || favoriteCars.isEmpty) {
            return Center(child: Text(l10n.no_favorites_yet));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: favoriteCars.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final car = favoriteCars[index];
              return CarCard(car: car);
            },
          );
        },
      ),
    );
  }
}
