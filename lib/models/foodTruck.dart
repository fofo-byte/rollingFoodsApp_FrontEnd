class Foodtruck {
  int id;
  String name;
  String description;

  Foodtruck({
    required this.id,
    required this.name,
    required this.description,
});


  factory Foodtruck.fromJson(Map<String, dynamic> json) {
    return Foodtruck(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };


}