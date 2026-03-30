import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Follow.dart';
import 'package:flutter_application_1/models/FollowRelation.dart';

class FollowService {
  final String baseUrl = 'http://api.papacapim.just.pro.br';

  Future<List<Follow>> getFollowers(String login, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$login/followers'),
      headers: {
        'x-session-token': token,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Follow.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar seguidores');
    }
  }

  Future<List<Follow>> getFollowing(String login, String token) async {
    // A API Papacapim não possui endpoint /following
    return [];
  }

  Future<FollowRelation?> followUser(String login, String token) async {
    print('>>> [followUser] Tentando seguir: $login');

    final response = await http.post(
      Uri.parse('$baseUrl/users/$login/followers'),
      headers: {
        'x-session-token': token,
        'Content-Type': 'application/json',
      },
    );

    print('>>> [followUser] Status: ${response.statusCode}');
    print('>>> [followUser] Body: ${response.body}');

    if (response.statusCode == 201) {
      print('[followUser] Seguindo $login com sucesso!');
      return FollowRelation.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 422) {
      print('[followUser] Já estava seguindo $login. Sincronizando estado...');
      return null;
    } else {
      throw Exception('Erro ao seguir: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> unfollowUser(String login, int followRelationId, String token) async {
    print('>>> [unfollowUser] Tentando deixar de seguir: $login');
    print('>>> [unfollowUser] followRelationId: $followRelationId');
    print('>>> [unfollowUser] Token: $token');

    final response = await http.delete(
      Uri.parse('$baseUrl/users/$login/followers/$followRelationId'),
      headers: {
        'x-session-token': token,
      },
    );

    print('>>> [unfollowUser] Status: ${response.statusCode}');

    if (response.statusCode == 204) {
      print('[unfollowUser] Deixou de seguir $login com sucesso!');
    } else {
      throw Exception('Erro ao deixar de seguir: ${response.statusCode} - ${response.body}');
    }
  }
}
