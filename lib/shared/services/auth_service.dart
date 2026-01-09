import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:autopaleis/shared/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import '../../core/config/oauth_config.dart';

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
      var url = Uri.parse('${dotenv.env['API_BASE_URL']}/api/authenticate');
      
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

        var accountUrl = Uri.parse('${dotenv.env['API_BASE_URL']}/api/AM/account');
        final accResponse = await http.get(
          accountUrl,
          headers: _token != null ? {'Authorization': 'Bearer $_token'} : {},
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
      var url = Uri.parse('${dotenv.env['API_BASE_URL']}/api/AM/account');
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
      var url = Uri.parse('${dotenv.env['API_BASE_URL']}/api/AM/account');
      
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

  Future<bool> loginWithGitHub() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authorizationUrl =
          Uri.https('github.com', '/login/oauth/authorize', {
            'client_id': OAuthConfig.githubClientId,
            'redirect_uri': OAuthConfig.githubRedirectUri,
            'scope': OAuthConfig.githubScopes.join(' '),
            'state': _generateRandomState(),
          });

      final result = await FlutterWebAuth2.authenticate(
        url: authorizationUrl.toString(),
        callbackUrlScheme: 'autopaleis',
      );

      // Extract authorization code from callback
      final code = Uri.parse(result).queryParameters['code'];

      if (code == null) {
        _error = 'Authorization code not received';
        notifyListeners();
        return false;
      }

      // Exchange authorization code for access token
      final tokenResponse = await http.post(
        Uri.parse(OAuthConfig.githubTokenEndpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'client_id': OAuthConfig.githubClientId,
          'client_secret': OAuthConfig.githubClientSecret,
          'code': code,
          'redirect_uri': OAuthConfig.githubRedirectUri,
        }),
      );

      if (tokenResponse.statusCode != 200) {
        _error = 'Failed to exchange code for token';
        notifyListeners();
        return false;
      }

      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];

      if (accessToken == null) {
        _error = 'Access token not received';
        notifyListeners();
        return false;
      }

      final userResponse = await http.get(
        Uri.parse(OAuthConfig.githubUserEndpoint),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (userResponse.statusCode != 200) {
        _error = 'Failed to fetch user information';
        notifyListeners();
        return false;
      }

      final githubUser = json.decode(userResponse.body);

      // Get GitHub email - if null, fetch from emails API
      String? githubEmail = githubUser['email'];
      if (githubEmail == null || githubEmail.isEmpty) {
        final emailResponse = await http.get(
          Uri.parse('https://api.github.com/user/emails'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        );
        if (emailResponse.statusCode == 200) {
          final emails = json.decode(emailResponse.body) as List;
          final primaryEmail = emails.firstWhere(
            (e) => e['primary'] == true,
            orElse: () => emails.isNotEmpty ? emails.first : null,
          );
          githubEmail = primaryEmail?['email'];
        }
      }

      // Use GitHub ID-based username to avoid conflicts
      final githubUsername = 'github_${githubUser['id']}';
      final githubPassword = 'GithubOAuth2024!_${githubUser['id']}';

      // Try to login first
      var loginUrl = Uri.parse('${dotenv.env['API_BASE_URL']}/api/authenticate');
      var loginResponse = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': githubUsername,
          'password': githubPassword,
          'rememberMe': true,
        }),
      );

      // If login fails (user doesn't exist), try to register
      if (loginResponse.statusCode != 200) {
        var registerUrl = Uri.parse('${dotenv.env['API_BASE_URL']}/api/register');

        var registerResponse = await http.post(
          registerUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'login': githubUsername,
            'email': githubEmail,
            'password': githubPassword,
            'firstName':
                githubUser['name']?.split(' ').first ?? githubUser['login'],
            'lastName': githubUser['name']?.split(' ').skip(1).join(' ') ?? '',
            'langKey': 'en',
          }),
        );

        if (registerResponse.statusCode == 200 || registerResponse.statusCode == 201) {
          loginResponse = await http.post(
            loginUrl,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'username': githubUsername,
              'password': githubPassword,
              'rememberMe': true,
            }),
          );
        } else {
          _error = 'Registration failed (${registerResponse.statusCode})';
          notifyListeners();
          return false;
        }
      }

      // Extract backend token
      if (loginResponse.statusCode == 200) {
        final data = json.decode(loginResponse.body);
        _token = data['id_token'];

        // Fetch user account from backend
        var accountUrl = Uri.parse('${dotenv.env['API_BASE_URL']}/api/AM/account');
        final accResponse = await http.get(
          accountUrl,
          headers: {'Authorization': 'Bearer $_token'},
        );

        if (accResponse.statusCode == 200) {
          _currentUser = parse(accResponse.body);
        }

        notifyListeners();
        return true;
      } else {
        _error = 'Backend authentication failed: ${loginResponse.statusCode}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'GitHub OAuth error: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _generateRandomState() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    return random;
  }
}
