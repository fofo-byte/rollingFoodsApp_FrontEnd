import 'dart:ffi';

import 'package:flutter/material.dart';

class User {
  int? id;
  String username;
  String email;
  String password;
  String? role;
  String? token;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.role = '',
    this.token = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] != null ? json['id'] as int : 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };
}
