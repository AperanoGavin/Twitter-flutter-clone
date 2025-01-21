import 'dart:convert';

import '../ApiClient.dart';
import '../../model/user.dart';
import '../../model/auth/AuthenticatedUser.dart';

class AuthApi {
  final ApiClient _apiClient = ApiClient();

  Future<void> register(User user) async {
  try {
    final response = await _apiClient.post('auth/register', user.toJson());

    if (response.statusCode == 201) {
      print('Utilisateur créé avec succès');
    } else if (response.statusCode == 400) {
      throw Exception('Erreur lors de la création de l\'utilisateur: ${response.body}');

      //print('Erreur lors de la création de l\'utilisateur: ${response.body}');
    } else {
      throw Exception('Erreur inconnue: ${response.statusCode}');

      //print('Erreur inconnue: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur de connexion ou de traitement: $e');

    //print('Erreur de connexion ou de traitement: $e');
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
