import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';

class ApiService {
  // The URL of the API's endpoint
  final String baseUrl = 'http://10.0.2.2:8686/api/foodTruck';

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
}
