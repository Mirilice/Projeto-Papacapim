import 'package:flutter_application_1/models/Like.dart';
import 'package:flutter_application_1/models/Post.dart';
import 'package:flutter_application_1/services/PostService.dart';

class PostRepository {
  final PostService _service;

  PostRepository(this._service);

  Future<List<Post>> getPosts(String token, {int page = 1, int feed = 0, String search = ''}) =>
      _service.getPosts(token, page: page, feed: feed, search: search);

  Future<Post> createPost(String token, String message) =>
      _service.createPost(token, message);

  Future<Post> replyPost(String token, int postId, String message) =>
      _service.replyPost(token, postId, message);

  Future<List<Post>> getReplies(String token, int postId) =>
      _service.getReplies(token, postId);

  Future<void> deletePost(String token, int postId) =>
      _service.deletePost(token, postId);

  Future<List<Post>> getUserPosts(String token, String login) =>
      _service.getUserPosts(token, login);

  Future<List<Like>> getLikes(String token, int postId) => _service.getLikes(token, postId);

  Future<int> likePost(String token, int postId) => _service.likePost(token, postId);

  Future<void> unlikePost(String token, int postId, int likeId) => _service.unlikePost(token, postId, likeId);
}
