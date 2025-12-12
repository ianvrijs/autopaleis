import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/rental_model.dart';

class RentalService with ChangeNotifier {
  List<RentalModel> _rentalList = [];
  bool _isLoading = false;
  String? _error;
  String? _authToken;

  List<RentalModel> get rentalList => _rentalList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setAuthToken(String token) {
    _authToken = token;
    notifyListeners();
  }

  Future<void> fetchRentals() async {
    _isLoading = true;
    notifyListeners();

    try {
      var url = Uri.parse('http://localhost:8080/api/rentals');

      final response = await http.get(
        url,
        headers: _authToken != null
            ? {'Authorization': 'Bearer $_authToken'}
            : {},
      );

      if (response.statusCode == 200) {
        _rentalList = parseList(response.body);
      } else {
        _error = "Failed to fetch rentals: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Fetch error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static List<RentalModel> parseList(String jsonString) {
    final List<dynamic> parsed = json.decode(jsonString);
    return parsed
        .map((e) => RentalModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<RentalModel> fetchRentalById(int id) async {
  var url = Uri.parse('http://localhost:8080/api/rentals/$id');

  final response = await http.get(
    url,
    headers: _authToken != null ? {'Authorization': 'Bearer $_authToken'} : {},
  );

  if (response.statusCode == 200) {
    return RentalModel.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to load rental: ${response.statusCode}");
  }
}

}
