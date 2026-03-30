class UpdateUser {
  int? id;
  String? login;
  String? name;
  String? password;
  String? createdAt; 

  UpdateUser({this.id, this.login, this.name, this.password, this.createdAt});

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
    id: json['id'], 
    login: json['login'],
    name: json['name'],
    password: null,
    createdAt: json['created_at'], 
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> userData = {};
    if (login != null && login!.isNotEmpty) userData['login'] = login;
    if (name != null && name!.isNotEmpty) userData['name'] = name;
    if (password != null && password!.isNotEmpty) {
      userData['password'] = password;
      userData['password_confirmation'] = password;
    }
    return {"user": userData};
  }
}