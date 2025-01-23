import 'dart:convert';
import '../../ApiClient.dart';
import '../../../model/post/post.dart';

class PostApi {
  final ApiClient _apiClient = ApiClient();

  Future<void> createPost(String content, String? imageUrl, String? parentId) async {
    await _apiClient.post('posts', {
      'content': content,
      'imageUrl': imageUrl,
      'parent': parentId,
    });
  }

  /* Future<String> fetchPosts() async {
      final response = await _apiClient.get('posts');
      return response.body;
    } */

  Future<List<Post>> get() async {
    try {
      final response = await _apiClient.get('/posts');
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> toggleLike(String postId) async {
    await _apiClient.post('posts/like/$postId', {});
  }

  
}
