class Post {
  final int id;
  final String userLogin;
  final int? postId; 
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.userLogin,
    this.postId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      userLogin: json['user_login'] ?? '',
      postId: json['post_id'],
      message: json['message'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}
