import 'dart:convert';
import 'package:flutter_application_1/models/UserPost.dart';
import 'package:http/http.dart' as http;

class Papacapimservice {
  final String _baseUrl = "https://api.papacapim.just.pro.br";

  Future<UserPost> createUser(UserPost post) async{
    
    http.Client client = http.Client();
    try{
      http.Response? res = await client.post(
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
    }finally{
      client.close();
    }
  }
}