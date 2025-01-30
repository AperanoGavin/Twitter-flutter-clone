
import 'package:esgix/core/model/post/post.dart';
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}

//for all likes to an individual post
class PostLikersLoaded extends PostState {
  final List<Author> likers;

  PostLikersLoaded(this.likers);
}