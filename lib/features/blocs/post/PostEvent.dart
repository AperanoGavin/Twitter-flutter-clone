import 'package:esgix/core/model/post/post.dart';

abstract class PostEvent {}

class LoadPosts extends PostEvent {
  final int page;
  final int pageSize;
  final String? parent;
  final String? userId;
  final String? userAllPostsLike;
  
  LoadPosts({
    this.page = 0,
    this.pageSize = 10, // Utilisation de l'offset de l'API
    this.parent,
    this.userId,
    this.userAllPostsLike
  }) {
    print('LoadPosts constructor - parent userAllPostsLike: $userAllPostsLike'); 
  }

}

class LikePost extends PostEvent {
  final String postId;

  LikePost({required this.postId});
}

class CreatePost extends PostEvent {
  final PostCreate postCreate;

  CreatePost({required this.postCreate});
}

class UpdatePost extends PostEvent {
  final String postId;
  final PostCreate postCreate;

  UpdatePost({required this.postId, required this.postCreate}); 

}

class DeletePost extends PostEvent {
  final String postId;

  DeletePost({required this.postId});
}


class LoadPostLikers extends PostEvent {
  final String postId;

  LoadPostLikers({required this.postId});
}

//search posts screen implementation

class SearchPosts extends PostEvent {
  final String query;

  SearchPosts({required this.query});
}

class CancelSearch extends PostEvent {}


//post details

class LoadPostDetails extends PostEvent {
  final String postId;

  LoadPostDetails({required this.postId});
}

