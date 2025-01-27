
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/blocs/post/PostState.dart';
import 'package:esgix/repositories/postRepository.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<LikePost>(_onLikePost);
    /*on<CreatePost>(_onCreatePost);
    on<DeletePost>(_onDeletePost); */
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final posts = await postRepository.getPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

   Future<void> _onLikePost(LikePost event, Emitter<PostState> emit) async {
    try {
      await postRepository.likePost(event.postId);
      final currentState = state as PostLoaded;
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
            final isLiked = !post.isLiked;
            final likesCount = isLiked ? post.likesCount + 1 : post.likesCount - 1;
          return post.copyWith(likesCount: likesCount, isLiked: isLiked);
      }
        return post;
      }).toList();
      emit(PostLoaded(updatedPosts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
 /*
  Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    try {
      await postRepository.createPost(
        content: event.content,
        imageUrl: event.imageUrl,
        parentId: event.parentId,
      );
      add(LoadPosts(page: 1)); // Recharger les posts après création
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      await postRepository.deletePost(event.postId);
      add(LoadPosts(page: 1)); // Recharger les posts après suppression
    } catch (e) {
      emit(PostError(e.toString()));
    }
  } */
}