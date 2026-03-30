import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Post.dart';
import 'package:flutter_application_1/models/Like.dart';

class PostService {
  final String baseUrl = 'https://api.papacapim.just.pro.br';

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'x-session-token': token,
      };
  Future<List<Post>> getPosts(String token, {int page = 1, int feed = 0, String search = ''}) async {
    final uri = Uri.parse('$baseUrl/posts').replace(queryParameters: {
      'page': '$page',
      if (feed == 1) 'feed': '1',
      if (search.isNotEmpty) 'search': search,
    });

    final response = await http.get(uri, headers: _headers(token));
    print('>>> [getPosts] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Post.fromJson(j)).toList();
    } else {
      throw Exception('Erro ao carregar posts: ${response.statusCode}');
    }
  }

  Future<Post> createPost(String token, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: _headers(token),
      body: jsonEncode({'post': {'message': message}}),
    );
    print('>>> [createPost] Status: ${response.statusCode} | Body: ${response.body}');

    if (response.statusCode == 201) {
      print('[createPost] Post criado com sucesso!');
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar post: ${response.statusCode}');
    }
  }

  /// Responde a um post existente.
  Future<Post> replyPost(String token, int postId, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/replies'),
      headers: _headers(token),
      body: jsonEncode({'reply': {'message': message}}),
    );
    print('>>> [replyPost] Status: ${response.statusCode} | Body: ${response.body}');

    if (response.statusCode == 201) {
      print('[replyPost] Resposta enviada com sucesso!');
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao responder post: ${response.statusCode}');
    }
  }

  Future<List<Post>> getReplies(String token, int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/replies'),
      headers: _headers(token),
    );
    print('>>> [getReplies] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Post.fromJson(j)).toList();
    } else {
      throw Exception('Erro ao carregar respostas: ${response.statusCode}');
    }
  }

  /// Deleta um post do usuário logado.
  Future<void> deletePost(String token, int postId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$postId'),
      headers: _headers(token),
    );
    print('>>> [deletePost] Status: ${response.statusCode}');

    if (response.statusCode == 204) {
      print('[deletePost] Post deletado com sucesso!');
    } else {
      throw Exception('Erro ao deletar post: ${response.statusCode}');
    }
  }

Future<List<Post>> getUserPosts(String token, String login) async {
  final uri = Uri.parse('$baseUrl/users/$login/posts');

  print('>>> [getUserPosts] URL: $uri');
  final response = await http.get(uri, headers: _headers(token));
  print('>>> [getUserPosts] Status: ${response.statusCode}');
  print('>>> [getUserPosts] Body: ${response.body}');

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((j) => Post.fromJson(j)).toList();
  } else {
    throw Exception('Erro ao carregar posts do usuário: ${response.statusCode}');
  }
}

  Future<List<Like>> getLikes(String token, int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/likes'),
      headers: _headers(token),
    );
    print('>>> [getLikes] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Like.fromJson(j)).toList();
    } else {
      throw Exception('Erro ao carregar curtidas: ${response.statusCode}');
    }
  }

  Future<int> likePost(String token, int postId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/likes'),
      headers: _headers(token),
    );
    print('>>> [likePost] Status: ${response.statusCode} | Body: ${response.body}');

    if (response.statusCode == 201) {
      print('[likePost] Curtido com sucesso!');
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Erro ao curtir: ${response.statusCode}');
    }
  }

  Future<void> unlikePost(String token, int postId, int likeId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$postId/likes/$likeId'),
      headers: _headers(token),
    );
    print('>>> [unlikePost] Status: ${response.statusCode}');

    if (response.statusCode == 204) {
      print('[unlikePost] Descurtido com sucesso!');
    } else {
      throw Exception('Erro ao descurtir: ${response.statusCode}');
    }
  }
}
