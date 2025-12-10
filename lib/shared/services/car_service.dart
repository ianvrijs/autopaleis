import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:autopaleis/shared/models/car_model.dart';
import 'package:flutter/material.dart';

class CarService with ChangeNotifier {
  List<CarModel> _carList = [];
  bool _isLoading = false;
  String? _error;
  String? _authToken;
  int _currentPage = 0;
  bool _hasMoreData = true;
  final int _pageSize = 20;

  List<CarModel> get carList => _carList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMoreData => _hasMoreData;

  void setAuthToken(String token) {
    _authToken = token;
    notifyListeners();
  }

  Future<void> fetchCars({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _carList = [];
      _hasMoreData = true;
      _error = null;
    }

    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    try {
      var url = Uri.parse(
        'http://localhost:8080/api/cars?page=$_currentPage&size=$_pageSize'
      );
      
      final response = await http.get(
        url,
        headers: _authToken != null 
            ? {'Authorization': 'Bearer $_authToken'}
            : {},
      );
      
      if (response.statusCode == 200) {
        final newCars = parse(response.body);
        
        if (newCars.isEmpty || newCars.length < _pageSize) {
          _hasMoreData = false;
        }
        
        _carList.addAll(newCars);
        _currentPage++;
        _error = null;
      } else {
        _error = 'Failed to fetch cars: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Fetch error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static List<CarModel> parse(String jsonString) {
    List<dynamic> parsedJson = json.decode(jsonString);
    return parsedJson
        .map((e) => CarModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}