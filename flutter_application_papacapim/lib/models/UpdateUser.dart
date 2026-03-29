class UpdateUser {
  String? login;
  String? name;
  String? password;

  UpdateUser({this.login, this.name, this.password});

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
    login: json['login'],
    name: json['name'],
    password: null, 
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> userData = {};

    if (login != null && login!.isNotEmpty) userData['login'] = login;
    if (name != null && name!.isNotEmpty) userData['name'] = name;
    
    if (password != null && password!.isNotEmpty) {
      userData['password'] = password;
      userData['password_confirmation'] = password;
    }

    return {
      "user": userData
    };
  }
}