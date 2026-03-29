class UserSession {
  final int id;
  final String login;
  final String token;
  final String ip;
  final String created_at;
  final String updated_at;
  final String password;

  UserSession({
    required this.id,
    required this.login, 
    required this.token, 
    required this.ip,
    required this.created_at,
    required this.updated_at,
    required this.password
  });

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
    id: json['id'] ?? 0,
    login: json['login'] ?? json['user_login'] ?? '', 
    token: json['token'] ?? '',
    ip: json['ip'] ?? '',
    created_at: json['created_at'] ?? '',
    updated_at: json['updated_at'] ?? '',
    password: '',
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "user_login": login,
    "token": token,
    "ip": ip,
    "created_at":created_at,
    "updated_at":updated_at
  };
}