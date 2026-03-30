class Like {
  final int id;
  final String userLogin;
  final int postId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Like({
    required this.id,
    required this.userLogin,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'] ?? 0,
      userLogin: json['user_login'] ?? '',
      postId: json['post_id'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}
