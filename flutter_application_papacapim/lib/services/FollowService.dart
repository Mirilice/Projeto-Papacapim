import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Follow.dart';
import 'package:flutter_application_1/models/FollowRelation.dart';

class FollowService {
  final String baseUrl = 'https://papacapim.just.pro.br';

  Future<List<Follow>> getFollowers(String login) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$login/followers'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Follow.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar seguidores');
    }
  }

  Future<List<Follow>> getFollowing(String login) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$login/following'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Follow.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar seguindo');
    }
  }

  Future<FollowRelation> followUser(String login, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$login/followers'),
      headers: {
        'x-session-token': token,
        'Content-Type': 'application/json',
      },
    );
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      return FollowRelation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao seguir');
    }
  }

  Future<void> unfollowUser(String login, int myUserId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$login/followers/$myUserId'),
      headers: {
        'x-session-token': token,
      },
    );
    
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Erro ao deixar de seguir');
    }
  }
}