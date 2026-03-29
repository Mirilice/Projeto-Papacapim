import 'package:flutter_application_1/models/UserPost.dart';
import 'package:flutter_application_1/services/PapacapimService.dart';

class CreateUserRepository {
  final Papacapimservice _apiService;
  CreateUserRepository(this._apiService);
  Future<UserPost> createUser(UserPost post) async => _apiService.createUser(post);
}
