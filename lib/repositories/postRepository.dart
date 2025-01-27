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

  //likePost

  Future<void> likePost(String postId) async {
    try {
      await _postApi.toggleLike(postId);
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

}