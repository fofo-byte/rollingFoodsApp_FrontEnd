import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rolling_foods_app_front_end/models/foodTruckOwner.dart';
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

  // Register a new FoodTruckOwner with the API

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

  Future<User> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signIn'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('Successfully logged in user: $jsonResponse');

      if (!jsonResponse.containsKey('token')) {
        throw Exception('Token not found in response');
      }

      String token = jsonResponse['token'];

      Map<String, dynamic> decodedToken = parseJwtEnabled(token);

      print('Decoded Token: $decodedToken');
      print(
          'Enabled from token: ${decodedToken['enabled']} (type: ${decodedToken['enabled'].runtimeType})');

      // Créez l'objet User en utilisant les données décodées
      User user = User(
        id: decodedToken['id'] ?? 0,
        username: decodedToken['username'] ?? '',
        email: decodedToken['email'] ?? '',
        password: '', // Vous n'avez pas besoin de stocker le mot de passe
        role: decodedToken['roles'] != null && decodedToken['roles'].isNotEmpty
            ? decodedToken['roles'][0]['authority'] ?? ''
            : '',
        token: token,
        enabled: decodedToken['enabled'] ?? false,
      );

      print(user.toJson());

      print(
          'Enabled from token: ${decodedToken['enabled']} (type: ${decodedToken['enabled'].runtimeType})');
      print(
          'Enabled from user: ${user.enabled} (type: ${user.enabled.runtimeType})');

      // Stockez les informations dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token);
      await prefs.setInt('id', user.id);
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);
      await prefs.setString('role', user.role);
      await prefs.setBool('enabled', user.enabled);

      print('Successfully logged in user: $jsonResponse');
      return user;
    } else if (response.statusCode == 401) {
      throw Exception('Incorrect email or password');
    } else if (response.statusCode == 403) {
      throw Exception('User is disabled');
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      print('Failed to log in user, status code: ${response.statusCode}');
      throw Exception('Failed to log in user');
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

  //check if the user is a food truck owner
  Future<bool> isFoodTruckOwner(int userCredentialId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/isFoodTruckOwner?userCredentialId=$userCredentialId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print(
          'Successfully checked if user is a food truck owner: ${response.body}');
      return json.decode(response.body) as bool;
    } else {
      print(
          'Failed to check if user is a food truck owner, status code: ${response.statusCode}');
      throw Exception('Failed to check if user is a food truck owner');
    }
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Efface toutes les données stockées
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

  // Decode the token from JWT
  Map<String, dynamic> parseJwtEnabled(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token format');
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));

    // Decode the JSON payload
    Map<String, dynamic> jsonPayload = json.decode(resp);

    // Ensure 'enabled' is correctly interpreted as a boolean
    if (jsonPayload.containsKey('enabled')) {
      var enabledValue = jsonPayload['enabled'];
      if (enabledValue is int) {
        jsonPayload['enabled'] = (enabledValue == 1);
      } else if (enabledValue is bool) {
        jsonPayload['enabled'] = enabledValue;
      } else {
        // Handle unexpected type or set a default value
        jsonPayload['enabled'] = false;
      }
    }

    return jsonPayload;
  }

  //update the user's password
  Future<void> updatePassword(String email, String password) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updatePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Successfully updated password');
    } else {
      print('Failed to update password, status code: ${response.statusCode}');
      throw Exception('Failed to update password');
    }
  }

  //Delete account user from the API
  Future<void> deleteAccount(int userCredentialId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/deleteAccount?userCredentialId=$userCredentialId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('Successfully deleted account');
    } else {
      print('Failed to delete account, status code: ${response.statusCode}');
      throw Exception('Failed to delete account');
    }
  }
}
