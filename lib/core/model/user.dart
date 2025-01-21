class User{
    final String username;
    final String email;
    final String password;
    final Uri? avatar;

    User({
      required this.username,
      required this.email,
      required this.password,
      this.avatar

    }) : assert(email.isNotEmpty, 'Email cannot be empty'),
         assert(username.isNotEmpty , 'Username cannot be empty');

    factory User.fromJson(Map<String, dynamic> json) {
      return User(
        username: json['username'] as String,
        email: json['email'] as String , 
        password : json['password'] as String,
        avatar: json['avatar'] != null ? Uri.tryParse(json['avatar'] as String) : null,
      );
    }

    Map<String, dynamic> toJson(){
      return {
        'username': username, 
        'email': email,
        'password': password,
        'avatar': avatar?.toString(),
      };
    }

}