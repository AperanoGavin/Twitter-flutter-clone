import 'package:esgix/core/model/post/post.dart';

abstract class PostEvent {}

class LoadPosts extends PostEvent {
  final int page;
  final bool loadMore;

  LoadPosts({required this.page  , this.loadMore = false});
  @override
  List<Object?> get props => [page, loadMore];

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

//for all likes to an individual post

class LoadPostLikers extends PostEvent {
  final String postId;

  LoadPostLikers({required this.postId});
}

//loadMore

