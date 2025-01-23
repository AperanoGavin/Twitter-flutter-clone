import '../ApiClient.dart';


class UserApi {
  final ApiClient _apiClient = ApiClient();

  Future<void> updateUser(String username, String? avatar, String? description) async {
    await _apiClient.put('user/update', {
      'username': username,
      'avatar': avatar,
      'description': description,
    });
  }
}
