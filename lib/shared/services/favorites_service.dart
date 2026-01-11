import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/car_model.dart';

class FavoritesService with ChangeNotifier {
  final Set<String> _favoriteCarIds = {};
  bool _isLoaded = false;

  Set<String> get favoriteCarIds => _favoriteCarIds;
  String? _token;

  void setAuthToken(String token) {
      _token = token;
    }

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

  Future<List<CarModel>> fetchFavoriteCars(String authToken) async {
    await loadFavorites();
    if (_favoriteCarIds.isEmpty) {
      return [];
    }

    try {
      final List<Future<CarModel>> futureCars = _favoriteCarIds.map((id) {
        return _fetchCarById(id);
      }).toList();

      final cars = await Future.wait(futureCars);
      return cars;
    } catch (e) {
      // Rethrow the exception to be caught by the FutureBuilder
      rethrow;
    }
  }

  Future<CarModel> _fetchCarById(String carId) async {
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/api/cars/$carId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      return CarModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch car with id $carId: ${response.statusCode}');
    }
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
