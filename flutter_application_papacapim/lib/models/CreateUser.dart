class CreateUser {
  String login;
  String name;
  String password;

  CreateUser({required this.login, required this.name, required this.password});

  factory CreateUser.fromJson(Map<String, dynamic> json) => CreateUser(
    login: json['login'] ?? '',
    name: json['name'] ?? '',
    password: ''
  );
  Map<String, dynamic> toJson() => {
    "user":{
      "login":login,
      "name":name,
      "password":password,
      "password_confirmation":password
    }
  };
}