import 'package:flutter_application_1/models/CreateUser.dart';
import 'package:flutter_application_1/models/UpdateUser.dart';
import 'package:flutter_application_1/models/UserSession.dart';
import 'package:flutter_application_1/services/UserService.dart';
import 'dart:async';

class UserRepository {
  final UserService _apiService;
  UserRepository(this._apiService);

  Future<UserSession> createUser(CreateUser user) async => _apiService.createUser(user);

  Future<UserSession> userLogin(String login, String password) async{
    try{
      UserSession session = await _apiService.userLogin(login,password);

      return session;
    }catch(e){
      rethrow;
    }
  }

  Future<UpdateUser> getUserByLogin(String login, String token) => _apiService.getUserByLogin(login, token);

  Future<UpdateUser> getUserProfile(String login, String token) async {
    try {
      return await _apiService.getUserByLogin(login, token);
    } catch (e) {
      rethrow;
    }
  }
  Future<UpdateUser> userPatch(int userId, UpdateUser updateData, String token) async {
    try {
      return await _apiService.userUpdate(userId, updateData, token);
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> deleteUser(int userId, String token) async => _apiService.deleteUser(userId, token);
}

