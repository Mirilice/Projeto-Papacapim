import 'dart:convert';
import 'package:flutter_application_1/models/CreateUser.dart';
import 'package:flutter_application_1/models/UpdateUser.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:http/http.dart' as http;

class UserService {
  final http.Client _client = http.Client();
  final String _baseUrl = "https://api.papacapim.just.pro.br";

  Future<UserSession> createUser(CreateUser post) async { 
  try {
    http.Response res = await _client.post(
      Uri.parse('$_baseUrl/users'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(post.toJson()),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      return UserSession.fromJson(json.decode(res.body));
    } else {
      throw Exception("Erro na API: ${res.statusCode}: ${res.body}");
    }
  } catch (e) {
    return Future.error(e);
  }
}
  Future<UserSession> userLogin(String login, String password) async{
    
    try{
      http.Response? res = await _client.post(
        Uri.parse('$_baseUrl/sessions'),
        headers: {
          "Content-Type":"application/json"
        },
        body:json.encode({
          "login":login,
          "password":password
        })
      );
      if(res.statusCode == 200){
        return UserSession.fromJson(json.decode(res.body));
      }else{
        throw Exception("Erro na API: ${res.statusCode}: ${res.body}");
      }
      
    }catch(e){
      return Future.error(e);
    }
  }

    Future<UpdateUser> userUpdate(int userId, UpdateUser updateData, String token) async{
    
    try{
      http.Response? res = await _client.patch(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: {
          "Content-Type":"application/json",
          "x-session-token": token
        },
        body:json.encode(updateData.toJson())
      );
      if(res.statusCode == 200 || res.statusCode == 201){
        return UpdateUser.fromJson(json.decode(res.body));
      }else{
        throw Exception("Erro na API: ${res.statusCode}: ${res.body}");
      }
      
    }catch(e){
      return Future.error(e);
    }
  }

  Future<UpdateUser> getUserByLogin(String login, String token) async {
  try {
    final res = await _client.get(
      Uri.parse('$_baseUrl/users/$login'),
      headers: {
        "Content-Type": "application/json",
        "x-session-token": token
      },
    );

    if (res.statusCode == 200) {
      return UpdateUser.fromJson(json.decode(res.body));
    } else {
      print("${res.statusCode} - ${res.body}");
      throw Exception("Usuário não encontrado: ${res.statusCode}");
    }
  } catch (e) {
    return Future.error(e);
  }
}
}