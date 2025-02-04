import 'dart:convert';
import '../../ApiClient.dart';
import '../../../model/post/post.dart';

class PostApi {
  final ApiClient _apiClient = ApiClient();

  Future<void> createPost(PostCreate postCreate) async {
    await _apiClient.post('posts', {
      'content': postCreate.content,
      'imageUrl': postCreate.imageUrl,
      'parent': postCreate.parent,
    });
  }

  Future<void> updatePost(PostCreate postCreate, String postId) async {
    await _apiClient.put('posts/$postId', {
      'content': postCreate.content,
      'imageUrl': postCreate.imageUrl,
      'parent': postCreate.parent,
    });
  }

  Future<void> deletePost(String postId) async {
    await _apiClient.delete('posts/$postId');
  }


  Future<List<Post>> get(int page , String? parent) async {
    try {
      final response = await _apiClient.get('posts?parent=$parent&&page=$page');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Api error Failed to load posts');
    }
  }

  Future<Post> getPostById(String postId) async {
    final response = await _apiClient.get('posts/$postId');
    return Post.fromJson(json.decode(response.body));
  }

  Future<void> toggleLike(String postId) async {
    await _apiClient.post('likes/$postId', {});
  }

  Future<List<Author>> getPostLikers(String postId) async {
    final response = await _apiClient.get('likes/$postId/users');
    return (json.decode(response.body) as List)
        .map((e) => Author.fromJson(e))
        .toList();
  }

  Future<List<Post>> getPostsByUser(String userId) async {
    final response = await _apiClient.get('users/$userId/posts?offset=1000000');
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Post.fromJson(json)).toList();
  }

   Future<List<Post>> searchPosts(String query) async {
    final response = await _apiClient.get('search?query=$query');
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> jsonList = jsonResponse['data'];
    return jsonList.map((json) => Post.fromJson(json)).toList();

   }


  
}
