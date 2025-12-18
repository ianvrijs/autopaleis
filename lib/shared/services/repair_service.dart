import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/repair_model.dart';

class RepairService with ChangeNotifier {
  final List<Repair> _repairs = [];
  bool _isLoading = false;
  String? _error;
  String? _token;

  List<Repair> get repairs => _repairs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setAuthToken(String token) {
    _token = token;
  }

  Future<void> fetchRepairs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('http://localhost:8080/api/repairs');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _repairs
          ..clear()
          ..addAll(data.map((e) => Repair.fromJson(e)));
      } else {
        _error = 'Failed to load repairs';
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createRepair({
    required int carId,
    required String description,
  }) async {
    try {
      final url = Uri.parse('http://localhost:8080/api/repairs');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'description': description,
          'repairStatus': 'PLANNED',
          'car': {
            'id': carId,
          },
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchRepairs();
      } else {
        throw Exception('Failed to create repair: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating repair: $e');
    }
  }
}
