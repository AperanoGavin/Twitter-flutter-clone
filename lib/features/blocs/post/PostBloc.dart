
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:esgix/features/blocs/post/PostEvent.dart';
import 'package:esgix/features/blocs/post/PostState.dart';
import 'package:esgix/repositories/postRepository.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  int currentPage = 0;


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
      if (state is PostLoaded) {
        // En cas de rafraîchissement, on ne veut pas garder l'ancien état
        if (event.page == 0) {
          emit(PostLoading());
        }
      } else {
        emit(PostLoading());
      }

      final newPosts = await postRepository.getPosts(event.page);
      
      print('Loading page: ${event.page}');
      print('New posts count: ${newPosts.length}');
      print('Has reached max: ${newPosts.length < event.pageSize}');

      if (state is PostLoaded && event.page > 0) { //en gros plus on charge plus on ajoute les nouveaux posts à la liste existante
        final currentState = state as PostLoaded;
        final updatedPosts = [...currentState.posts, ...newPosts]; // ici on ajoute les nouveaux posts à la liste existante
        
        emit(PostLoaded(
          updatedPosts,
          event.page,
          hasReachedMax: newPosts.length < event.pageSize
        ));
      } else {
        emit(PostLoaded(
          newPosts,
          event.page,
          hasReachedMax: newPosts.length < event.pageSize
        ));
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
      emit(PostLoaded(updatedPosts, currentState.currentPage));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    try {
      await postRepository.createPost(event.postCreate);
      add(LoadPosts()); 
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
    try {
      
      await postRepository.updatePost(event.postCreate , event.postId);
      add(LoadPosts()); // Reload posts after update
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      await postRepository.deletePost(event.postId);
      add(LoadPosts()); 
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