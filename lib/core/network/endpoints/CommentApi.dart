import '../ApiClient.dart';


class CommentApi {
  final ApiClient _apiClient = ApiClient();

  Future<void> createComment(String content, String parentId) async {
    await _apiClient.post('posts/create', {
      'content': content,
      'parent': parentId,
    });
  }

  Future<String> fetchComments(String parentId) async {
    final response = await _apiClient.get('posts?parent=$parentId');
    return response.body;
  }
}
