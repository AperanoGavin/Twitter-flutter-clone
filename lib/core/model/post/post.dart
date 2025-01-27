class Author {
  final String id;
  final String username;
  final String? avatar;

  Author({
    required this.id,
    required this.username,
    this.avatar,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar']??' ',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
    };
  }
}

class Post {
  final String content;
  final String? parent;
  final DateTime createdAt;
  final String? imageUrl;
  final int commentsCount;
  final Author author;
  final String id;
  final int likesCount;
  final DateTime updatedAt;

  Post({
    required this.content,
    this.parent = '',
    required this.createdAt,
    this.imageUrl = '',
    this.commentsCount = 0,
    required this.author,
    required this.id,
    this.likesCount = 0,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'],
      parent: json['parent'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      imageUrl: json['imageUrl'] ?? '',
      commentsCount: json['commentsCount'] ?? 0,
      author: Author.fromJson(json['author']),
      id: json['id'],
      likesCount: json['likesCount'] ?? 0,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

 /*  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'parent': parent,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'commentsCount': commentsCount,
      'author': author.toJson(),
      'id': id,
      'likesCount': likesCount,
      'updatedAt': updatedAt.toIso8601String(),
    };
  } */
}