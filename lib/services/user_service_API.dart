import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rolling_foods_app_front_end/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServiceApi {
// The URL of the API's endpoint
  final String baseUrl = 'http://10.0.2.2:8686/api';

  // Register a new user with the API

  Future<User> registerUser(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('Successfully registered user: $jsonResponse');
      return User.fromJson(jsonResponse);
    } else {
      print('Failed to register user, status code: ${response.statusCode}');
      throw Exception('Failed to register user');
    }
  }

  // Login a user with the API

  Future<User> loginUser(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signIn'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('Successfully logged in user: $jsonResponse');

      if (!jsonResponse.containsKey('token')) {
        throw Exception('Token not found is missing in response');
      }

      String token = jsonResponse['token'];

      Map<String, dynamic> decodedToken = parseJwt(token);
      if (!decodedToken.containsKey('username')) {
        throw Exception('Username not found in token');
      }

      String username = decodedToken['username'];
      String decodeEmail = decodedToken['email'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('username', username);
      await prefs.setString('email', decodeEmail);

      print('Successfully logged in user: $jsonResponse');
      return User.fromJson(jsonResponse);
    } else {
      print('Failed to login user, status code: ${response.statusCode}');
      throw Exception('Failed to login user');
    }
  }

  //Decode the token from jwt
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    return json.decode(resp);
  }
}
