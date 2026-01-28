import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

import '../models/rental_model.dart';
import '../models/rental_summary.dart';

class RentalService with ChangeNotifier {
  List<RentalModel> _rentalList = [];
  bool _isLoading = false;
  String? _error;
  String? _authToken;

  String get _apiUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null) {
      throw Exception(".env file is missing API_BASE_URL");
    }
    return url;
  }

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
      var url = Uri.parse('${dotenv.env['API_BASE_URL']}/api/rentals');

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
    var url = Uri.parse('$_apiUrl/api/rentals/$id');

    final response = await http.get(url, headers: _authToken != null ? {'Authorization': 'Bearer $_authToken'} : {},);

    if (response.statusCode == 200) {
      return RentalModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load rental: ${response.statusCode}");
    }
  }

  Future<RentalSummary> createRental(int carId, int customerId) async {
    var url = Uri.parse('$_apiUrl/api/rentals');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_authToken',
      },
      body: jsonEncode({
        'car': {'id': carId},
        'customer': {'id': customerId},
        'fromDate': DateTime.now().toIso8601String(),
        'toDate': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      return RentalSummary.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create rental. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<RentalModel> startRentalRide(int rentalId, double latitude, double longitude) async {
    final String rideCode = const Uuid().v4().substring(0, 8);

    final response = await http.patch(
      Uri.parse('$_apiUrl/api/rentals/$rentalId'),
      headers: {
        'Content-Type': 'application/merge-patch+json',
        'Authorization': 'Bearer $_authToken',
      },
      body: jsonEncode({
        'id': rentalId,
        'state': 'ACTIVE',
        'code': rideCode,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      return RentalModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to start ride. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<RentalModel> endRentalRide(int rentalId, double latitude, double longitude) async {
    final response = await http.patch(
      Uri.parse('$_apiUrl/api/rentals/$rentalId'),
      headers: {
        'Content-Type': 'application/merge-patch+json',
        'Authorization': 'Bearer $_authToken',
      },
      body: jsonEncode({
        'id': rentalId,
        'state': 'RETURNED',
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return RentalModel.fromJson(responseBody);
    } else {
      throw Exception('Failed to end ride. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
