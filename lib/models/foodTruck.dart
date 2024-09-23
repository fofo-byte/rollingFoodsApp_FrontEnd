import 'package:rolling_foods_app_front_end/models/coordinates.dart';

class Foodtruck {
  int id;
  String name;
  String description;
  String speciality;
  String foodTypes;
  String? urlProlfileImage;
  int? rating;
  Coordinates? coordinates;

  Foodtruck({
    required this.id,
    required this.name,
    required this.description,
    required this.speciality,
    required this.foodTypes,
    this.urlProlfileImage,
    this.coordinates,
    this.rating,
  });

  factory Foodtruck.fromJson(Map<String, dynamic> json) {
    return Foodtruck(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      speciality: json['speciality'],
      urlProlfileImage: json['profileImage'],
      // Convert the list of pictures to a list of Picture objects
      coordinates: Coordinates.fromJson(json['coordinates']),
      // Convert the coordinates to a Coordinates object
      foodTypes: json['foodType'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'speciality': speciality,
        'coordinates': coordinates!.toJson(),
        'profileImage': urlProlfileImage,
        'foodType': foodTypes,
        'rating': rating,
      };
}
