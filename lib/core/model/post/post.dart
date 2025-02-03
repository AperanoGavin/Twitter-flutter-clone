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
  final bool? likedByUser;

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
    this.likedByUser , 
  });

  Post copyWith({
    String? id,
    String? content,
    String? imageUrl,
    String? parent,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Author? author,
    bool? likedByUser, 

  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      parent: parent ?? this.parent,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      likedByUser: likedByUser ?? this.likedByUser, 

    );
  }

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
      likedByUser: json['likedByUser'] ?? false, 

    );
  }
}

class PostCreate {
  final String content;
  final String? imageUrl;
  final String? parent;

  PostCreate({
    required this.content,
    this.imageUrl,
    this.parent,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'imageUrl': imageUrl,
      'parent': parent,
    };
  }
}