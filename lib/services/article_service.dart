import 'dart:convert';

import 'package:rolling_foods_app_front_end/models/article.dart';
import 'package:http/http.dart' as http;

class ArticleService {
  // The URL of the API's endpoint
  final String baseUrl = 'http://10.0.2.2:8686/api/items';

  Future<List<Article>> getItemsByFoodTruckIdAndCategory(
      int foodTruckId, String category) async {
    try {
      print('Fetching articles from $baseUrl');
      final response = await http.get(Uri.parse(
          '$baseUrl/foodTruckAndCategory/foodTruckId=$foodTruckId&category=$category'));

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

  Future<Article> createArticle(Article article, int foodTruckId) async {
    // Create article on the server

    return article;
  }

  Future<Article> updateArticle(Article article) async {
    // Update article on the server
    return article;
  }

  Future<void> deleteArticle(int id) async {
    // Delete article on the server
  }
}
