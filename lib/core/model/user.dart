class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;
  final String? description;
  final String created;
  final String updated;
  final bool emailVisibility;
  final bool verified;
  final String apiKey;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    this.description,
    required this.created,
    required this.updated,
    required this.emailVisibility,
    required this.verified,
    required this.apiKey
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      description: json['description'] as String?,
      created: json['created'] as String,
      updated: json['updated'] as String,
      emailVisibility: json['emailVisibility'] as bool,
      verified: json['verified'] as bool,
      apiKey: json['api_key'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'description': description,
      'created': created,
      'updated': updated,
      'emailVisibility': emailVisibility,
      'verified': verified,
      'api_key': apiKey
    };
  }
}