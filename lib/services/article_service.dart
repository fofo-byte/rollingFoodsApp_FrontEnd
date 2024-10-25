import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:rolling_foods_app_front_end/models/article.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleService {
  // The URL of the API's endpoint
  final String baseUrl = 'http://10.0.2.2:8686/api/items';

  Future<List<Article>> getItemsByFoodTruckIdAndCategory(
      int foodTruckId, String category) async {
    try {
      // Construire l'URL avec les paramètres foodTruckId et category
      final uri = Uri.parse('$baseUrl/foodTruckAndCategory').replace(
          queryParameters: {
            'foodTruckId': foodTruckId.toString(),
            'category': category
          });

      print('Fetching articles from: $uri');

      // Effectuer la requête HTTP GET
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Successfully fetched articles: $jsonResponse');
        return jsonResponse
            .map((article) => Article.fromJson(article))
            .toList();
      } else {
        print('Failed to load articles, status code: ${response.statusCode}');
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Failed to load articles: $e');
      throw Exception('Failed to load articles');
    }
  }

  //Création de l'article
  Future<http.Response> createArticle({
    required String name,
    required String description,
    required double price,
    required String itemCategorie,
    required File? pictureItem,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    int? foodTruckOwnerId = await ApiService().findIdFoodTruckOwner(id!);
    int foodTruckId =
        await ApiService().getFoodTruckIdByOwnerId(foodTruckOwnerId);
    print('Food truck id addArticle: $foodTruckId');
    // Créer le JSON pour les données de l'article
    Map<String, dynamic> articleData = {
      'name': name,
      'description': description,
      'price': price,
      'itemCategorie': itemCategorie,
    };

    String json = jsonEncode(articleData);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl?foodTruckId=$foodTruckId'),
    );

    request.files.add(http.MultipartFile.fromString('itemDTO', json,
        filename: 'itemDTO.json',
        contentType: MediaType('application', 'json')));

    if (pictureItem != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pictureItem.path,
        contentType: MediaType.parse(lookupMimeType(pictureItem.path) ?? ''),
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Successfully created article');
      return http.Response.fromStream(response);
    }
    if (response.statusCode == 201) {
      print('Successfully created article');
      return http.Response.fromStream(response);
    }
    if (response.statusCode == 400) {
      print('Failed to create article, status code: ${response.statusCode}');
      throw Exception('Failed to create article');
    }
    if (response.statusCode == 403) {
      print('Failed to create article, status code: ${response.statusCode}');
      throw Exception('Failed to create article');
    }

    if (response.statusCode == 500) {
      print('Failed to create article, status code: ${response.statusCode}');
      throw Exception('Failed to create article');
    } else {
      print('Failed to create article, status code: ${response.statusCode}');
      throw Exception('Failed to create article');
    }
  }

  //Suppression de l'article
  Future<void> deleteArticle(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        print('Successfully deleted article with id: $id');
      } else {
        print('Failed to delete article, status code: ${response.statusCode}');
        throw Exception('Failed to delete article');
      }
    } catch (e) {
      print('Failed to delete article: $e');
      throw Exception('Failed to delete article');
    }
  }

  //Liste des articles par food truck
  Future<List<Article>> getItemsByFoodTruckId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    int? foodTruckOwnerId = await ApiService().findIdFoodTruckOwner(id!);
    int foodTruckId =
        await ApiService().getFoodTruckIdByOwnerId(foodTruckOwnerId);
    print('Food truck id items: $foodTruckId');
    try {
      final uri = Uri.parse('$baseUrl/foodTruck?foodTruckId=$foodTruckId');
      print('Fetching articles from: $uri');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print('Successfully fetched articles: $jsonResponse');
        return jsonResponse
            .map((article) => Article.fromJson(article))
            .toList();
      } else {
        print('Failed to load articles, status code: ${response.statusCode}');
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Failed to load articles: $e');
      throw Exception('Failed to load articles');
    }
  }

  //Update de l'article
  Future<http.Response> updateArticleById({
    required int id,
    required String name,
    required String description,
    required double price,
    required String itemCategorie,
    File? pictureFile,
  }) async {
    // Création des données JSON pour l'article
    Map<String, dynamic> articleData = {
      'name': name,
      'description': description,
      'price': price,
      'itemCategorie': itemCategorie,
    };

    String jsonArticleData = jsonEncode(articleData);

    // Configuration de la requête multipart
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/$id'),
    );

    // Ajouter l'article JSON en tant que fichier de champ itemDTO
    request.files.add(
      http.MultipartFile.fromString(
        'itemDTO',
        jsonArticleData,
        filename: 'itemDTO.json',
        contentType: MediaType('application', 'json'),
      ),
    );

    // Ajouter l'image si elle est présente
    if (pictureFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          pictureFile.path,
          contentType: MediaType.parse(lookupMimeType(pictureFile.path) ?? ''),
        ),
      );
    }

    // Envoyer la requête et attendre la réponse
    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print('Successfully updated article');
      return http.Response('Successfully updated article', 200);
    } else {
      print('Failed to update article, status code: ${response.statusCode}');
      throw Exception('Failed to update article');
    }
  }

  //Récupération de l'article par son id
  Future<Article> fetchArticleById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Successfully fetched article: $jsonResponse');
        return Article.fromJson(jsonResponse);
      } else {
        print('Failed to load article, status code: ${response.statusCode}');
        throw Exception('Failed to load article');
      }
    } catch (e) {
      print('Failed to load article: $e');
      throw Exception('Failed to load article');
    }
  }
}
