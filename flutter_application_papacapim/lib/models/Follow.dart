class Follow {
  final int id;
  final String login;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Follow({
    required this.id,
    required this.login,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
  return Follow(
    id: json['id'] ?? 0,
    login: json['login'] ?? '',
    name: json['name'] ?? '',
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now(),
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : DateTime.now(),
  );
}
}