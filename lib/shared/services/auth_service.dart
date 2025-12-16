import 'package:autopaleis/shared/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  String? _token;
  String? _error;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
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

        var accountUrl = Uri.parse('http://localhost:8080/api/AM/account');
        final accResponse = await http.get(
          accountUrl,
          headers: _token != null 
              ? {'Authorization': 'Bearer $_token'}
              : {},
        );
        if (accResponse.statusCode == 200) {
          final user = parse(accResponse.body);
          _currentUser = user;
          // print('Login response4: ${_currentUser?.username}');
        }

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
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _fetchUserData() async {
    try {
      var url = Uri.parse('http://localhost:8080/api/AM/account');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final user = parse(response.body);
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<bool> updateUserInfo({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      var url = Uri.parse('http://localhost:8080/api/AM/account');
      
      final authorities = _currentUser?.authorities;
      
      final body = {
        'id': int.tryParse(_currentUser?.id ?? '0') ?? 0,
        'login': _currentUser?.username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'activated': true,
        'langKey': 'en',
        'authorities': authorities,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode(body),
      );
      
      if (response.statusCode == 200) {
        // Fetch updated user data from backend
        await _fetchUserData();
        notifyListeners();
        return true;
      } else {
        _error = 'Update failed: ${response.statusCode}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Update error: $e';
      notifyListeners();
      return false;
    }
  }

  static User parse(String jsonString) {
    Map<String, dynamic> parsedJson = json.decode(jsonString);
    return User.fromJson(parsedJson);
  }

  bool get isAdmin {
  return _currentUser?.authorities.contains('ROLE_ADMIN') ?? false;
  }

  bool get isUser {
    return _currentUser?.authorities.contains('ROLE_USER') ?? false;
}

  bool hasRole(String role) {
    return _currentUser?.authorities.contains(role) ?? false;
  }
}
