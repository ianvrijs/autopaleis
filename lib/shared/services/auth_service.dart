import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  String? _token;
  String? _error;
  bool _isLoading = false;

  String? get token => _token;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      var url = Uri.parse('http://localhost:8080/api/authenticate');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'rememberMe': true,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['id_token'];
        notifyListeners();

        return true;
      } else {
        _error = 'Login failed: ${response.statusCode}';
        notifyListeners();

        return false;
      }
    } catch (e) {
      _error = 'Login error: $e';
      notifyListeners();

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
