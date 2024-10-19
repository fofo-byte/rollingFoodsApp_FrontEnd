import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/services/authInterceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final client =
      InterceptedClient.build(interceptors: [AuthInterceptor()]);
  // The URL of the API's endpoint
  final String baseUrl = 'http://10.0.2.2:8686/api/foodTruck';

  //Fetch all food trucks
  Future<List<Foodtruck>> fetchFoodTrucks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      print('Fetching food trucks from $baseUrl');
      final response = await http.get(Uri.parse(baseUrl), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

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
    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:8686/api/findFoodTruckOwnerIdByUserCredentialId?userCredentialId=$userCredentialId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
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

  //Create a food truck with multipart request

  Future<http.Response> createFoodTruck({
    required String name,
    required String description,
    required String speciality,
    required List<String> foodTypes,
    required File imageFile,
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

    // Ajouter l'image du food truck comme une partie multipart
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

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
    required List<String> foodTypes,
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

  //Get favorite food trucks
  Future<List<Foodtruck>> getFavoriteFoodTrucks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    try {
      print('Fetching favorite food trucks for user with id $id');
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8686/api/favorite?userId=$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Successfully fetched favorite food trucks: $jsonResponse');
        return jsonResponse
            .map((foodTruck) => Foodtruck.fromJson(foodTruck))
            .toList();
      } else {
        print(
            'Failed to load favorite food trucks, status code: ${response.statusCode}');
        throw Exception('Failed to load favorite food trucks');
      }
    } catch (e) {
      print('Failed to load favorite food trucks: $e');
      throw Exception('Failed to load favorite food trucks');
    }
  }

  //Add a food truck to favorites
  Future<void> addFavoriteFoodTruck(int foodTruckId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');

    try {
      print('Adding food truck with id $foodTruckId to favorites for user $id');
      final response = await http.post(
          Uri.parse(
              'http://10.0.2.2:8686/api/favorite?userId=$id&foodTruckId=$foodTruckId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        print('Successfully added food truck to favorites');
      } else {
        print(
            'Failed to add food truck to favorites, status code: ${response.statusCode}');
        throw Exception('Failed to add food truck to favorites');
      }
    } catch (e) {
      print('Failed to add food truck to favorites: $e');
      throw Exception('Failed to add food truck to favorites');
    }
  }

  //isFavoriteFoodTruck
  Future<bool> isFavoriteFoodTruck(int foodTruckId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');

    print('Checking if food truck with id $foodTruckId is a favorite');
    final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8686/api/isFavorite?userId=$id&foodTruckId=$foodTruckId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      bool jsonResponse = json.decode(response.body);
      print('Successfully checked if food truck is a favorite: $jsonResponse');
      return jsonResponse;
    } else {
      print(
          'Failed to check if food truck is a favorite, status code: ${response.statusCode}');
      throw Exception('Failed to check if food truck is a favorite');
    }
  }

  //Delete a food truck from favorites
  Future<void> deleteFavoriteFoodTruck(int foodTruckId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');

    try {
      print(
          'Deleting food truck with id $foodTruckId from favorites for user $id');
      final response = await http.delete(
          Uri.parse(
              'http://10.0.2.2:8686/api/favorite?userId=$id&foodTruckId=$foodTruckId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        print('Successfully deleted food truck from favorites');
      } else {
        print(
            'Failed to delete food truck from favorites, status code: ${response.statusCode}');
        throw Exception('Failed to delete food truck from favorites');
      }
    } catch (e) {
      print('Failed to delete food truck from favorites: $e');
      throw Exception('Failed to delete food truck from favorites');
    }
  }

  //Get food trucks by icon filter
  Future<List<Foodtruck>> getFoodTrucksByIconFilter(String foodType) async {
    try {
      print('Fetching food trucks by icon filter $foodType');
      final response = await http.get(
          Uri.parse(
              'http://10.0.2.2:8686/api/foodTruckByFoodType?foodType=$foodType'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Successfully fetched food trucks by icon filter: $jsonResponse');
        return jsonResponse
            .map((foodTruck) => Foodtruck.fromJson(foodTruck))
            .toList();
      } else {
        print(
            'Failed to load food trucks by icon filter, status code: ${response.statusCode}');
        throw Exception('Failed to load food trucks by icon filter');
      }
    } catch (e) {
      print('Failed to load food trucks by icon filter: $e');
      throw Exception('Failed to load food trucks by icon filter');
    }
  }

  //Search food trucks
  Future<List<Foodtruck>> searchFoodTrucks(String searchTerm) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8686/api/searchFoodTrucks?searchTerm=$searchTerm'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((foodTruck) => Foodtruck.fromJson(foodTruck))
            .toList();
      } else {
        throw Exception('Failed to search food trucks');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
