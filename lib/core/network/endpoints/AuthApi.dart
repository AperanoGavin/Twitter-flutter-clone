import 'dart:convert';

import '../ApiClient.dart';
import '../../model/user/user.dart';
import '../../model/auth/AuthenticatedUser.dart';
import '../../model/auth/register/RegisterUser.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthApi {
  final ApiClient _apiClient = ApiClient();

Future<AuthenticatedUser> register(RegisterUser registerUser) async {
  try {
    final registrationData = {
      'username': registerUser.username,
      'email': registerUser.email,
      'password': registerUser.password, 
      'avatar': registerUser.avatar ?? "",
      
    };

    final response = await _apiClient.post('auth/register', registrationData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      final user = AuthenticatedUser.fromJson(responseBody);
      print('AuthenticatedUser: $user');
      return AuthenticatedUser.fromJson(responseBody);
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error during registration: $e');
  }
}



  Future<AuthenticatedUser> login(String email, String password) async {
    final response = await _apiClient.post('auth/login', {
      'email': email,
      'password': password,
    });

    final data = jsonDecode(response.body);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', data['token']);
    prefs.setString('user', jsonEncode(data['record']));
    prefs.setString('id', data['record']['id'].toString());

    return AuthenticatedUser.fromJson(data);
  }
}
