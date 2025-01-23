class RegisterUser {
  final String username;
  final String email;
  final String password;
  final String? avatar;

  RegisterUser({
    required this.username,
    required this.email,
    required this.password,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'avatar': avatar ?? '',
    };
  }
}
