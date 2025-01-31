
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
    on<CreatePost>(_onCreatePost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost); 
    //likes per post
    on<LoadPostLikers>(_onLoadPostLikers);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    try {
      if (event.loadMore) {
        final currentState = state as PostLoaded;
        emit(PostLoadingMore(currentState.posts)); // État intermédiaire
      } else {
        emit(PostLoading());
      }

      final newPosts = await postRepository.getPosts(event.page);

      if (event.loadMore) {
        final currentState = state as PostLoadingMore;
        emit(PostLoaded([...currentState.posts, ...newPosts]));
      } else {
        emit(PostLoaded(newPosts));
      }
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

  Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    try {
      await postRepository.createPost(event.postCreate);
      add(LoadPosts(page: 0)); 
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
    try {
      
      await postRepository.updatePost(event.postCreate , event.postId);
      add(LoadPosts(page: 0)); // Reload posts after update
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      await postRepository.deletePost(event.postId);
      add(LoadPosts(page: 0)); 
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  //likes per post

  Future<void> _onLoadPostLikers(LoadPostLikers event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final postLikers = await postRepository.getPostLikers(event.postId);
      emit(PostLikersLoaded(postLikers));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

}