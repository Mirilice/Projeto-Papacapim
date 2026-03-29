class UserPost {
  String login;
  String name;
  String password;

  UserPost({required this.login, required this.name, required this.password});

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
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