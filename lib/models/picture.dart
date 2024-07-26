class Picture {
  final int id;
  final String name;
  final String location;

  Picture({
    required this.id,
    required this.name,
    required this.location,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
      };
}
