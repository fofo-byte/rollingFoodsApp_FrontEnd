import 'package:flutter/foundation.dart';

class Coordinates {
  double latitude = 50.47935;
  double longitude = 4.18563;

  Coordinates({Key? key, required this.latitude, required this.longitude});

//Factory constructor to create a new instance of Coordinates from a map
  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
