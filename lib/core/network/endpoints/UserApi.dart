import 'dart:convert';
import '../ApiClient.dart';
import '../../model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserApi {
  final ApiClient _apiClient = ApiClient();


   Future<User> fetchUser(String userId) async {
    final response = await _apiClient.get('users/$userId');
    return User.fromJson(json.decode(response.body));
  }

  /* Future<void> updateUser(UserUpdate  userUpdate ) async {
    await _apiClient.put('user/update', {
      'username': userUpdate.username,
      'avatar': userUpdate.avatar,
      'description': userUpdate.description,
    });
  } */


   Future<void> updateUser(UserUpdate userUpdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    if (userId == null) {
      throw Exception('User ID not found in cache');
    }
    final userInfo = await fetchUser(userId);
    if (userInfo.username == userUpdate.username) {
        await _apiClient.put('users/$userId', {
        //'username': userUpdate.username,
        'avatar': userUpdate.avatar,
        'description': userUpdate.description,
      });
    }else{
      await _apiClient.put('users/$userId', {
        'username': userUpdate.username,
        'avatar': userUpdate.avatar,
        'description': userUpdate.description,
      });
    }
  }

  Future<List<User>> getPostLikers(String postId) async {
    final response = await _apiClient.get('posts/$postId/likers');
    return (json.decode(response.body) as List)
        .map((e) => User.fromJson(e))
        .toList();
  }

  
}
