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
      id: json['id'],
      login: json['login'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}