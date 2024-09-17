import 'dart:ffi';

class Article {
  final int id;
  final String name;
  final String description;
  final String urlPicture;
  final Float price;
  final String itemCategorie;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.urlPicture,
    required this.price,
    required this.itemCategorie,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      urlPicture: json['pictureItem'],
      price: json['price'],
      itemCategorie: json['itemCategorie'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'pictureItem': urlPicture,
        'price': price,
        'itemCategorie': itemCategorie,
      };
}
