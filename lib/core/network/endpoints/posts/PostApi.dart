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


  Future<List<Post>> get() async {
    try {
      final response = await _apiClient.get('posts');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Api error Failed to load posts');
    }
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


  
}
