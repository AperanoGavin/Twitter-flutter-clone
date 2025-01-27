class User {
  final String id;
  final String username;
  final String? email;
  final String? avatar;
  final String? description;
  final String? created;
  final String? updated;
  final bool? emailVisibility;
  final bool? verified;
  final String? apiKey;

  User({
    required this.id,
    required this.username,
    this.email,
    this.avatar,
    this.description,
    this.created,
    this.updated,
    this.emailVisibility,
    this.verified,
    this.apiKey
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      /* id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      description: json['description'] as String?,
      created: json['created'] as String?,
      updated: json['updated'] as String?,
      emailVisibility: json['emailVisibility'] as bool?,
      verified: json['verified'] as bool?,
      apiKey: json['api_key'] as String? */

      id: json['id']?.toString() ?? '', // Conversion explicite en String
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString(), // Nullable
      avatar: json['avatar']?.toString(),
      description: json['description']?.toString(),
      created: json['created']?.toString(),
      updated: json['updated']?.toString(),
      emailVisibility: json['emailVisibility'] as bool?,
      verified: json['verified'] as bool?,
      apiKey: json['api_key']?.toString()
      
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

class UserUpdate {
  final String username;
  final String? avatar;
  final String? description;

  UserUpdate({
    required this.username,
    this.avatar,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'avatar': avatar,
      'description': description,
    };
  }
}

