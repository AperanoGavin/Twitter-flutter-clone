// lib/data/repositories/user_repository.dart
import '../core/model/user/user.dart';
import '../core/network/endpoints/UserApi.dart';
import 'package:esgix/services/AuthService.dart';

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

  Future<User> getCurrentUser() async{
    final authService = AuthService();
    final userId = await authService.getUserId();

    try {
      return await _userApi.fetchUser(userId!);
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

}