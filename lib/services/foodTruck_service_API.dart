import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // The URL of the API's endpoint
  final String baseUrl = 'http://10.0.2.2:8686/api/foodTruck';

  //Fetch all food trucks
  Future<List<Foodtruck>> fetchFoodTrucks() async {
    try {
      print('Fetching food trucks from $baseUrl');
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Successfully fetched food trucks: $jsonResponse');
        return jsonResponse
            .map((foodTruck) => Foodtruck.fromJson(foodTruck))
            .toList();
      } else {
        print(
            'Failed to load food trucks, status code: ${response.statusCode}');
        throw Exception('Failed to load food trucks');
      }
    } catch (e) {
      print('Failed to load food trucks: $e');
      throw Exception('Failed to load food trucks');
    }
  }

  //Fetch a food truck by id
  Future<Foodtruck> fetchFoodTruckById(int id) async {
    try {
      print('Fetching food truck with id $id from $baseUrl');
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Successfully fetched food truck: $jsonResponse');
        return Foodtruck.fromJson(jsonResponse);
      } else {
        print('Failed to load food truck, status code: ${response.statusCode}');
        throw Exception('Failed to load food truck');
      }
    } catch (e) {
      print('Failed to load food truck: $e');
      throw Exception('Failed to load food truck');
    }
  }

  //find id of the foodTruckOwner
  Future<int> findIdFoodTruckOwner(int userCredentialId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    if (id == null) {
      throw Exception('Failed to find id of the food truck owner');
    }
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8686/api/findFoodTruckOwnerIdByUserCredentialId?userCredentialId=$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse is int) {
        print('Successfully found id of the food truck owner: $jsonResponse');
        return jsonResponse; // Renvoie directement l'entier
      } else if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('id')) {
        print(
            'Successfully found id of the food truck owner: ${jsonResponse['id']}');
        return jsonResponse['id']; // Accède à l'ID dans l'objet JSON
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      print(
          'Failed to find id of the food truck owner, status code: ${response.statusCode}');
      throw Exception('Failed to find id of the food truck owner');
    }
  }

  //Pick image convert base64
  Future<String> pickImage(File image) async {
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
  //Create a food truck with multipart request

  Future<http.Response> createFoodTruck({
    required String name,
    required String description,
    required String speciality,
    required String foodTypes,
    required String profileImage,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    int foodTruckOwnerId = await findIdFoodTruckOwner(id!);

    // Créer le JSON pour les données du food truck
    Map<String, dynamic> foodTruckData = {
      'name': name,
      'description': description,
      'speciality': speciality,
      'foodType': foodTypes,
      'profileImage': profileImage,
      'coordinates': {
        'latitude': 50.4793576,
        'longitude': 4.18563,
      },
    };

    //Convertir les données du food truck en JSON
    String foodTruckJson = jsonEncode(foodTruckData);

    // Créer la requête HTTP
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://10.0.2.2:8686/api/addFoodTruck?ownerId=$foodTruckOwnerId'));

    // Ajouter le JSON des données du foodTruck comme une partie multipart
    request.files.add(
      http.MultipartFile.fromString(
        'foodTruck', // Le nom attendu par le backend
        foodTruckJson,
        filename: 'foodTruck.json',
        contentType: MediaType('application', 'json'),
      ),
    );

    // Envoyer la requête
    var response = await request.send();

    if (response.statusCode == 201) {
      print('Successfully created food truck');
      return http.Response('Success', 201);
    } else {
      print('Failed to create food truck, status code: ${response.statusCode}');
      throw Exception('Failed to create food truck');
    }
  }

  //Update a food truck
  // Mettre à jour un food truck
  Future<http.Response> updateFoodTruck({
    int? id,
    required String name,
    required String description,
    required String speciality,
    required String foodTypes,
    String? profileImage,
  }) async {
    try {
      // Créer le JSON pour les données du food truck
      Map<String, dynamic> foodTruckData = {
        'id': id,
        'name': name,
        'description': description,
        'speciality': speciality,
        'foodType': foodTypes,
        if (profileImage != null)
          'profileImage': profileImage, // Ajouter l'image si présente
      };

      // Convertir les données du food truck en JSON
      String foodTruckJson = jsonEncode(foodTruckData);

      // Créer la requête HTTP
      var request = http.MultipartRequest('PUT',
          Uri.parse('http://10.0.2.2:8686/api/updateFoodTruck?ownerId=$id'));

      // Ajouter le JSON des données du foodTruck comme une partie multipart
      request.files.add(
        http.MultipartFile.fromString(
          'foodTruck', // Le nom attendu par le backend
          foodTruckJson,
          filename: 'foodTruck.json',
          contentType: MediaType('application', 'json'),
        ),
      );

      // Envoyer la requête
      var response = await request.send();

      // Vérifier la réponse du serveur
      if (response.statusCode == 200) {
        print('Successfully updated food truck');
        return http.Response('Success', 200);
      } else {
        print(
            'Failed to update food truck, status code: ${response.statusCode}');
        throw Exception('Failed to update food truck');
      }
    } catch (e) {
      print('Failed to update food truck: $e');
      throw Exception('Failed to update food truck');
    }
  }

  //Delete a food truck
  Future<void> deleteFoodTruck(int id) async {
    try {
      print('Deleting food truck with id $id');
      final response = await http.delete(
          Uri.parse('http://10.0.2.2:8686/api/deleteFoodTruck?foodTruckId=$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 204) {
        print('Successfully deleted food truck with id $id');
      } else {
        print(
            'Failed to delete food truck, status code: ${response.statusCode}');
        throw Exception('Failed to delete food truck');
      }
    } catch (e) {
      print('Failed to delete food truck: $e');
      throw Exception('Failed to delete food truck');
    }
  }

  // Get food truck id by owner id
  Future<int> getFoodTruckIdByOwnerId(int ownerId) async {
    try {
      print('Fetching food truck id by owner id $ownerId');
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8686/api/foodTruckByOwnerId?ownerId=$ownerId'),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('No food truck found for owner id $ownerId');
          return 0;
        }

        String jsonResponse = response.body;
        int foodTruckId = int.parse(jsonResponse);
        print('Successfully fetched food truck id: $foodTruckId');
        return foodTruckId;
      } else {
        print(
            'Failed to load food truck id, status code: ${response.statusCode}');
        throw Exception('Failed to load food truck id');
      }
    } catch (e) {
      print('Failed to load food truck id: $e');
      throw Exception('Failed to load food truck id');
    }
  }

  //Open the food truck
  Future<http.Response> openFoodTruck(
      int id, double latitude, double longitude) async {
    try {
      // Créer le JSON pour les données du food truck
      Map<String, dynamic> foodTruckData = {
        'coordinates': {
          'latitude': latitude,
          'longitude': longitude,
        },
      };
      print('Opening food truck with id $id');
      final response = await http.put(
          Uri.parse('http://10.0.2.2:8686/api/openFoodTruck?foodTruckId=$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(foodTruckData));

      if (response.statusCode == 200) {
        print('Successfully opened food truck with id $id');
        return response;
      } else {
        print('Failed to open food truck, status code: ${response.statusCode}');
        throw Exception('Failed to open food truck');
      }
    } catch (e) {
      print('Failed to open food truck: $e');
      throw Exception('Failed to open food truck');
    }
  }

  //Close the food truck
  Future<http.Response> closeFoodTruck(int id) async {
    try {
      print('Closing food truck with id $id');
      final response = await http.put(
          Uri.parse('http://10.0.2.2:8686/api/closeFoodTruck?foodTruckId=$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        print('Successfully closed food truck with id $id');
        return response;
      } else {
        print(
            'Failed to close food truck, status code: ${response.statusCode}');
        throw Exception('Failed to close food truck');
      }
    } catch (e) {
      print('Failed to close food truck: $e');
      throw Exception('Failed to close food truck');
    }
  }

  //Get the status of the food truck
  Future<bool> getFoodTruckStatus(int id) async {
    try {
      print('Fetching status of food truck with id $id');
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8686/api/isFoodTruckOpen?foodTruckId=$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        bool jsonResponse = json.decode(response.body);
        print('Successfully fetched status of food truck: $jsonResponse');
        return jsonResponse;
      } else {
        print(
            'Failed to load status of food truck, status code: ${response.statusCode}');
        throw Exception('Failed to load status of food truck');
      }
    } catch (e) {
      print('Failed to load status of food truck: $e');
      throw Exception('Failed to load status of food truck');
    }
  }
}

    // Future<void> deleteFoodTruck(int id) async {
