import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rolling_foods_app_front_end/models/address.dart';
import 'package:rolling_foods_app_front_end/models/foodTruckOwner.dart';
import 'package:rolling_foods_app_front_end/models/user.dart';
import 'package:rolling_foods_app_front_end/screens/homeCustomer.dart';
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

  Future<User> registerFoodTruckOwner(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registerFoodTruckOwner'),
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

      int id = decodedToken['id'];
      String username = decodedToken['username'];
      String decodeEmail = decodedToken['email'];
      String role = decodedToken['roles'][0]['authority'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('id', id);
      await prefs.setString('username', username);
      await prefs.setString('email', decodeEmail);
      await prefs.setString('role', role);

      print('Successfully logged in user: $jsonResponse');
      return User.fromJson(jsonResponse);
    } else {
      print('Failed to login user, status code: ${response.statusCode}');
      throw Exception('Failed to login user');
    }
  }

  // Register a new FoodTruckOwner

  Future<Foodtruckowner> registerFoodTruckAccount(
      int userCredentialId,
      String firstname,
      String lastname,
      String phonenumber,
      String tva,
      String banknumber,
      String companyname,
      String street,
      String streetnumber,
      String city,
      String postalcode,
      String province,
      String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, dynamic> body = {
      'firstname': firstname,
      'lastname': lastname,
      'phoneNumber': phonenumber,
      'tva': tva,
      'bankNumber': banknumber,
      'companyName': companyname,
      'address': {
        'street': street,
        'streetNumber': streetnumber,
        'city': city,
        'postalCode': postalcode,
        'province': province,
        'country': country,
      },
    };
    final response = await http.post(
      Uri.parse(
          '$baseUrl/addFoodTruckOwner?userCredentialId=$userCredentialId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('Successfully registered user: $jsonResponse');

      int foodTruckOwnerId = jsonResponse['id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('foodTruckOwnerId', foodTruckOwnerId);

      return Foodtruckowner.fromJson(jsonResponse);
    } else {
      print('Failed to register user, status code: ${response.statusCode}');
      throw Exception('Failed to register user');
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
