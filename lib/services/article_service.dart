import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/models/article.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';

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
    required String pictureItem,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    int foodTruckId = await ApiService().findIdFoodTruckOwner(id!);

    // Créer le JSON pour les données de l'article
    Map<String, dynamic> articleData = {
      'name': name,
      'description': description,
      'price': price,
      'itemCategorie': itemCategorie,
      'pictureItem': pictureItem,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8686/api/items?foodTruckId=$foodTruckId')
          .replace(queryParameters: {
        'foodTruckId': foodTruckId.toString(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //Convertir les données du food truck en JSON
      body: jsonEncode(articleData),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print('Successfully created article: $jsonResponse');
      return response;
    } else {
      print('Failed to create article, status code: ${response.statusCode}');
      throw Exception('Failed to create article');
    }
  }

  //Mise à jour de l'article

  Future<Article> updateArticle(Article article) async {
    // Update article on the server
    return article;
  }

  //Suppression de l'article
  Future<void> deleteArticle(int id) async {
    // Delete article on the server
  }

  //Liste des articles par food truck
  Future<List<Article>> getItemsByFoodTruckId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    int foodTruckId = await ApiService().findIdFoodTruckOwner(id!);
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
}
