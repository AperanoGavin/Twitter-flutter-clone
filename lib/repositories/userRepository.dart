// lib/data/repositories/user_repository.dart
import '../core/model/user/user.dart';
import '../core/network/endpoints/UserApi.dart';

class UserRepository {
  final UserApi _userApi;

  UserRepository({required UserApi userApi}) : _userApi = userApi;

  Future<User> getUserById(String userId) async {
    try {
      return await _userApi.fetchUser(userId);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<void> updateProfile(UserUpdate userUpdate) async {
    try {
      await _userApi.updateUser(userUpdate);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Récupérer les likers d'un post
  Future<List<User>> getPostLikers(String postId) async {
    try {
      return await _userApi.getPostLikers(postId);
    } catch (e) {
      throw Exception('Failed to fetch likers: $e');
    }
  }
}