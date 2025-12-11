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
  List<String> _sortCriteria = [];

  List<CarModel> get carList => _carList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMoreData => _hasMoreData;
  List<String> get sortCriteria => _sortCriteria;

  void setAuthToken(String token) {
    _authToken = token;
    notifyListeners();
  }

  void setSortCriteria(List<String> criteria, {bool refresh = true}) {
    _sortCriteria = criteria;
    if (refresh) {
      fetchCars(refresh: true);
    } else {
      notifyListeners();
    }
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
      final queryParams = {
        'page': _currentPage.toString(),
        'size': _pageSize.toString(),
      };
      
      // Add sort parameters
      for (var sort in _sortCriteria) {
        queryParams['sort'] = sort;
      }
      
      var url = Uri.parse('http://localhost:8080/api/cars').replace(
        queryParameters: _sortCriteria.isEmpty 
            ? queryParams 
            : {
                ...queryParams,
                'sort': _sortCriteria,
              },
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