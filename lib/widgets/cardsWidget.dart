import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FoodTruckCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;
  final VoidCallback? onTap;
  final double rating;
  final String distance;

  FoodTruckCard({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.onTap,
    required this.rating,
    required this.distance,
  });

  Widget _buildImage() {
    bool isValideUrl =
        imageUrl.isEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true;
    return isValideUrl
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
            errorBuilder: (context, eroor, stackTrace) {
              print('Error loading image: $eroor');
              return Image.asset(
                'assets/images/foodtruck.jpg',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              );
            },
          )
        : Image.asset(
            'assets/images/foodtruck.jpg',
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: imageUrl.isEmpty
                  ? Image.asset(
                      'assets/images/foodtruck.jpg',
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.black54,
                        ),
                        Text(distance),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
