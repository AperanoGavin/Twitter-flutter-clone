import 'dart:convert';
import '../ApiClient.dart';
import '../../model/user/user.dart';


class UserApi {
  final ApiClient _apiClient = ApiClient();


   Future<User> fetchUser(String userId) async {
    final response = await _apiClient.get('users/$userId');
    return User.fromJson(json.decode(response.body));
  }

  Future<void> updateUser(UserUpdate  userUpdate ) async {
    await _apiClient.put('user/update', {
      'username': userUpdate.username,
      'avatar': userUpdate.avatar,
      'description': userUpdate.description,
    });
  }

  Future<List<User>> getPostLikers(String postId) async {
    final response = await _apiClient.get('posts/$postId/likers');
    return (json.decode(response.body) as List)
        .map((e) => User.fromJson(e))
        .toList();
  }

  
}
