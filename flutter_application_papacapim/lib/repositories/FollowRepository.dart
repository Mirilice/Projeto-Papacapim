import 'package:flutter_application_1/services/FollowService.dart';
import 'package:flutter_application_1/models/Follow.dart';
import 'package:flutter_application_1/models/FollowRelation.dart';

class FollowRepository {
  final FollowService _service;
  
  FollowRepository(this._service);

  Future<List<Follow>> getFollowers(String login) => _service.getFollowers(login);
  
  Future<List<Follow>> getFollowing(String login) => _service.getFollowing(login);
  
  Future<FollowRelation> followUser(String login, String token) => _service.followUser(login, token);
  
  Future<void> unfollowUser(String login, int myUserId, String token) => _service.unfollowUser(login, myUserId, token);
}