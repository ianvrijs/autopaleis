import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService with ChangeNotifier {
  final Set<String> _favoriteCarIds = {};
  bool _isLoaded = false;

  Set<String> get favoriteCarIds => _favoriteCarIds;

  Future<void> loadFavorites() async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    _favoriteCarIds.clear();
    for (final key in keys) {
      if (key.startsWith('favorite_')) {
        final isFavorite = prefs.getBool(key) ?? false;
        if (isFavorite) {
          final carId = key.substring('favorite_'.length);
          _favoriteCarIds.add(carId);
        }
      }
    }

    _isLoaded = true;
    notifyListeners();
  }

  bool isFavorite(String carId) {
    return _favoriteCarIds.contains(carId);
  }

  Future<void> toggleFavorite(String carId) async {
    final prefs = await SharedPreferences.getInstance();

    if (_favoriteCarIds.contains(carId)) {
      _favoriteCarIds.remove(carId);
      await prefs.setBool('favorite_$carId', false);
    } else {
      _favoriteCarIds.add(carId);
      await prefs.setBool('favorite_$carId', true);
    }

    notifyListeners();
  }

  static String getCarId(Map<String, dynamic> car) {
    return car['id']?.toString() ?? car['licensePlate']?.toString() ?? '';
  }
}
