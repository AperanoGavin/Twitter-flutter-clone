abstract class PostEvent {}

class LoadPosts extends PostEvent {
  final int page;

  LoadPosts({required this.page});
}

class LikePost extends PostEvent {
  final String postId;

  LikePost({required this.postId});
}

class CreatePost extends PostEvent {
  final String content;
  final String? imageUrl;
  final String? parentId;

  CreatePost({
    required this.content,
    this.imageUrl,
    this.parentId,
  });
}

class DeletePost extends PostEvent {
  final String postId;

  DeletePost({required this.postId});
}