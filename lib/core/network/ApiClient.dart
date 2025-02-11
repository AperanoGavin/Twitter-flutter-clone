import 'dart:convert'; // Import pour la conversion JSON.
import 'package:http/http.dart' as http; // Import pour effectuer des requêtes HTTP.
import 'package:shared_preferences/shared_preferences.dart'; // Import pour accéder aux préférences partagées (stockage local).

class ApiClient {
  // Déclaration des constantes pour l'URL de base et les clés d'API.
  static const String _baseUrl = "https://esgix.tech";
  static const String _apiKey = '5%ziCy)906"<';
  static const String _accessKey = "PMAT-01J976BQ3DB6GS3962V7CCKA9W";

  // Implémentation du pattern Singleton : une seule instance de ApiClient est créée.
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  // Méthode privée pour récupérer le token stocké dans SharedPreferences.
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Méthode pour effectuer une requête GET vers un endpoint donné.
  Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    // Utilise _sendRequest pour exécuter la requête et gérer les erreurs.
    return _sendRequest(() => http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    ));
  }

  // Méthode pour effectuer une requête POST avec un corps JSON.
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    return _sendRequest(() => http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body), // Encodage du corps en JSON.
    ));
  }

  // Méthode pour effectuer une requête PUT avec un corps JSON.
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    return _sendRequest(() => http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body), // Encodage du corps en JSON.
    ));
  }

  // Méthode pour effectuer une requête DELETE.
  Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();
    return _sendRequest(() => http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    ));
  }

  // Méthode privée pour construire les en-têtes HTTP, incluant l'authentification.
  Map<String, String> _buildHeaders(String? token) {
    return {
      'Authorization': token != null ? 'Bearer $token' : '', // Ajoute le token si présent.
      'x-api-key': _apiKey, // Ajoute la clé d'API.
      'access_key': _accessKey, // Ajoute la clé d'accès.
      'Content-Type': 'application/json', // Indique que le contenu est en JSON.
    };
  }

  // Méthode privée pour envoyer la requête et gérer la réponse.
  // Elle vérifie que le code de statut HTTP indique un succès (200-299).
  Future<http.Response> _sendRequest(Future<http.Response> Function() request) async {
    final response = await request(); // Exécute la requête.
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response; // Retourne la réponse si le statut est OK.
    } else {
      // Lève une exception en cas d'erreur avec le code et le contenu de la réponse.
      throw Exception('Erreur API : ${response.statusCode} - ${response.body}');
    }
  }
}
