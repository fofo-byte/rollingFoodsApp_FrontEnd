import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';

class Favoritespage extends StatefulWidget {
  const Favoritespage({super.key});

  @override
  State<Favoritespage> createState() => _FavoritespageState();
}

class _FavoritespageState extends State<Favoritespage> {
  Future<void> _deleteFavoriteFoodTruck(int foodTruckId) async {
    await ApiService().deleteFavoriteFoodTruck(foodTruckId);
    setState(() {
      ApiService().getFavoriteFoodTrucks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes food trucks preférés',
            style: TextStyle(color: Colors.black, fontFamily: 'GoogleSans')),
      ),
      body: Center(
        child: FutureBuilder<List<Foodtruck>>(
          future: ApiService().getFavoriteFoodTrucks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(5),
                    elevation: 5,
                    child: ListTile(
                      leading: IconButton(
                        tooltip: 'Supprimer des favoris',
                        color: Colors.red,
                        onPressed: () {
                          _deleteFavoriteFoodTruck(snapshot.data![index].id);
                        },
                        icon: const Icon(Icons.favorite),
                      ),
                      titleTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].description),
                      trailing: Image.network(
                          snapshot.data![index].urlProlfileImage!),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Foodtruckprofil(
                                foodtruckId: snapshot.data![index].id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
