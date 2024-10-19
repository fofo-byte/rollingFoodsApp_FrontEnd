import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/widgets/cardsWidget.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Foodtruck> foodTrucks;
  final Position currentPosition;

  const SearchResultsPage({
    Key? key,
    required this.foodTrucks,
    required this.currentPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats de recherche'),
      ),
      body: foodTrucks.isNotEmpty
          ? ListView.builder(
              itemCount: foodTrucks.length,
              itemBuilder: (context, index) {
                final foodTruck = foodTrucks[index];
                double distance = Geolocator.distanceBetween(
                  currentPosition.latitude,
                  currentPosition.longitude,
                  foodTruck.coordinates!.latitude,
                  foodTruck.coordinates!.longitude,
                );
                double distanceKm = distance / 1000;

                return FoodTruckCard(
                  name: foodTruck.name,
                  description: foodTruck.description,
                  rating: foodTruck.rating != null
                      ? foodTruck.rating!.toDouble()
                      : 0.0,
                  imageUrl: (foodTruck.urlProlfileImage != null &&
                          foodTruck.urlProlfileImage!.isNotEmpty)
                      ? foodTruck.urlProlfileImage!
                      : 'assets/images/foodtruck.jpg',
                  distance: '${distanceKm.toStringAsFixed(2)} km',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Foodtruckprofil(
                          foodtruckId: foodTruck.id,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text('Aucun résultat trouvé'),
            ),
    );
  }
}
