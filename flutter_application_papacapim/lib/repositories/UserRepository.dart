import 'package:flutter_application_1/models/UserPost.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'dart:async';

class UserRepository {
  final UserService _apiService;
  UserRepository(this._apiService);

  Future<UserPost> createUser(UserPost post) async => _apiService.createUser(post);

  Future<UserSession> userLogin(String login, String password) async{
    try{
      UserSession session = await _apiService.userLogin(login,password);

      return session;
    }catch(e){
      rethrow;
    }
  }
}
