import '../core/model/post/post.dart';
import '../core/network/endpoints/posts/PostApi.dart';


class PostRepository {
  final PostApi _postApi;

  PostRepository({required PostApi postApi}) : _postApi = postApi;



  Future<List<Post>> getPosts() async {
    try {
      return await _postApi.get();
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }


  Future<void> likePost(String postId) async {
    try {
      await _postApi.toggleLike(postId);
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  Future<void> createPost(PostCreate postCreate) async {
    try {
      await _postApi.createPost(postCreate);
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }


  Future<void> updatePost(PostCreate postCreate, String postId) async {
    try {
      await _postApi.updatePost(postCreate, postId);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _postApi.deletePost(postId);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
}