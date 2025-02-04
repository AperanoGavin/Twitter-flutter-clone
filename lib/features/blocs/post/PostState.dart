
import 'package:esgix/core/model/post/post.dart';
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {
  final bool loadMore;

  PostLoading({this.loadMore = false});
}

class PostLoaded extends PostState {
  final List<Post> posts;
  final int currentPage;
  final bool hasReachedMax;

  PostLoaded(this.posts, this.currentPage, {this.hasReachedMax = false});
}

class PostDetailsLoaded extends PostState {
  final Post post;

  PostDetailsLoaded(this.post);
}

class PostDetailsLoading extends PostState {}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}

//for all likes to an individual post
class PostLikersLoaded extends PostState {
  final List<Author> likers;

  PostLikersLoaded(this.likers);
}

class PostSearchLoaded extends PostState {
  final List<Post> posts;

  PostSearchLoaded(this.posts);
}

class PostSearchLoading extends PostState {}

class PostSearchFailure extends PostState {
  final String message;

  PostSearchFailure(this.message);
}

