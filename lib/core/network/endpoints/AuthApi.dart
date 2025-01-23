import 'dart:convert';

import '../ApiClient.dart';
import '../../model/user.dart';
import '../../model/auth/AuthenticatedUser.dart';
import '../../model/auth/register/RegisterUser.dart';

class AuthApi {
  final ApiClient _apiClient = ApiClient();

Future<AuthenticatedUser> register(RegisterUser registerUser) async {
  try {
    final registrationData = {
      'username': registerUser.username,
      'email': registerUser.email,
      'password': registerUser.password, 
      'avatar': registerUser.avatar?.toString() ?? ''
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
    return AuthenticatedUser.fromJson(data);
  }
}
