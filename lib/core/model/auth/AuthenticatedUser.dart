import 'package:esgix/core/model/user.dart';

class AuthenticatedUser {
  final User user;
  final String token;

  AuthenticatedUser({
    required this.user,
    required this.token

  });

  factory AuthenticatedUser.fromJson(Map<String , dynamic> json){
    return AuthenticatedUser(
      user: User.fromJson(json['record']),
      token: json['token'] as String,
    );
  }
}