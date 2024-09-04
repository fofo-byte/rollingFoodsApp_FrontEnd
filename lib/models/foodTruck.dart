import 'package:rolling_foods_app_front_end/models/coordinates.dart';
import 'package:rolling_foods_app_front_end/models/picture.dart';

class Foodtruck {
  int id;
  String name;
  String description;
  String speciality;
  String foodType;
  List<Picture> pictures;
  Coordinates coordinates;

  Foodtruck({
    required this.id,
    required this.name,
    required this.description,
    required this.speciality,
    required this.foodType,
    required this.pictures,
    required this.coordinates,
  });

  factory Foodtruck.fromJson(Map<String, dynamic> json) {
    return Foodtruck(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      speciality: json['speciality'],
      pictures: (json['pictures'] as List)
          .map((picture) => Picture.fromJson(picture))
          .toList(), // Convert the list of pictures to a list of Picture objects
      coordinates: Coordinates.fromJson(json['coordinates']),
      // Convert the coordinates to a Coordinates object
      foodType: json['foodType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'speciality': speciality,
        'coordinates': coordinates.toJson(),
        'pictures': pictures.map((picture) => picture.toJson()).toList(),
        'foodType': foodType,
      };
}
