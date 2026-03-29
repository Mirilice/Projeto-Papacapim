import 'dart:convert';
import 'package:flutter_application_1/models/UserPost.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:http/http.dart' as http;

class UserService {
  final http.Client _client = http.Client();
  final String _baseUrl = "https://api.papacapim.just.pro.br";

  Future<UserPost> createUser(UserPost post) async{
    
    try{
      http.Response? res = await _client.post(
        Uri.parse('$_baseUrl/users'),
        headers: {
          "Content-Type":"application/json"
        },
        body:json.encode(post.toJson())
      );
      if(res.statusCode == 201){
        return UserPost.fromJson(json.decode(res.body));
      }else{
        throw Exception("Erro na API: ${res.statusCode}: ${res.body}");
      }
      
    }catch(e){
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
}