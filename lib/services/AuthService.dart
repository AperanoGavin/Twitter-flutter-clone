import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    print('User ID from prefs: $userId'); // Debug print

    return userId;
  }

}