import 'package:rolling_foods_app_front_end/models/picture.dart';

class Foodtruck {
  int id;
  String name;
  String description;
  List<Picture> pictures;

  Foodtruck({
    required this.id,
    required this.name,
    required this.description,
    required this.pictures,
  });

  factory Foodtruck.fromJson(Map<String, dynamic> json) {
    return Foodtruck(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictures: (json['pictures'] as List)
          .map((picture) => Picture.fromJson(picture))
          .toList(), // Convert the list of pictures to a list of Picture objects
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'pictures': pictures.map((picture) => picture.toJson()).toList(),
      };
}
