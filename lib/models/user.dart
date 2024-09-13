import 'dart:ffi';

class User {
  int id;
  String username;
  String email;
  String password;
  String role;
  String token;
  bool enabled = false;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.token,
    required enabled,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: '',
      role: json['roles'] != null && json['roles'].isNotEmpty
          ? json['roles'][0]['authority'] ?? ''
          : '',
      token: json['token'] ?? '',
      enabled: json['enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };
}
