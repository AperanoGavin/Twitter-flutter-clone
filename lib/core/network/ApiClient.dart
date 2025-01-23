import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String _baseUrl = "https://esgix.tech";
  static const String _apiKey = '5%ziCy)906"<';
  static const String _accessKey = "PMAT-01J976BQ3DB6GS3962V7CCKA9W";


  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    return _sendRequest(() => http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    ));
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    return _sendRequest(() => http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    ));
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    return _sendRequest(() => http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    ));
  }

  Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();
    return _sendRequest(() => http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: _buildHeaders(token),
    ));
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      'Authorization': token != null ? 'Bearer $token' : '',
      'x-api-key': _apiKey,
      'access_key': _accessKey,
      'Content-Type': 'application/json',
    };
  }

  Future<http.Response> _sendRequest(Future<http.Response> Function() request) async {
    final response = await request();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Erreur API : ${response.statusCode} - ${response.body}');
    }
  }
}
