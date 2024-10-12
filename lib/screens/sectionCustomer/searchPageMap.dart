import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';

class Searchpagemap extends StatefulWidget {
  const Searchpagemap({super.key});

  @override
  State<Searchpagemap> createState() => _SearchpagemapState();
}

class _SearchpagemapState extends State<Searchpagemap> {
  late Future<List<Foodtruck>> foodTrucks;
  final MapController mapController = MapController();
  Map<int, String> foodTruckStatus = {};
  bool isOpened = false;

  final List<Marker> markers = <Marker>[];

  Future<void> _fetchFoodTruckStatus() async {
    final foodTruckList = await foodTrucks;
    for (var foodTruck in foodTruckList) {
      final isOpened = await ApiService().getFoodTruckStatus(foodTruck.id);
      String status = isOpened ? 'Closed' : 'Open';
      if (mounted) {
        setState(() {
          foodTruckStatus[foodTruck.id] = status;
          markers.add(Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(foodTruck.coordinates!.latitude,
                foodTruck.coordinates!.longitude),
            child: IconButton(
                icon: Icon(FontAwesomeIcons.locationDot,
                    size: 30, color: isOpened ? Colors.red : Colors.green),
                onPressed: () {
                  _showDetailsFoodTruck(context, foodTruck);
                }),
          ));
        });
      }
    }
  }

  void _showDetailsFoodTruck(BuildContext context, Foodtruck foodTruck) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // Supprimer les marges par défaut
          content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // 80% de la largeur de l'écran
            height: MediaQuery.of(context).size.height *
                0.10, // 10% de la hauteur de l'écran
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    radius: 30, // Diminuer la taille de l'image
                    backgroundImage: foodTruck.urlProlfileImage != null
                        ? NetworkImage(foodTruck.urlProlfileImage!)
                        : const AssetImage('assets/images/foodtruck.jpg')
                            as ImageProvider,
                  ),
                  title: Row(
                    children: [
                      Text(
                        foodTruck.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Text(
                        foodTruckStatus[foodTruck.id] ?? 'Closed',
                        style: TextStyle(
                            color: foodTruckStatus[foodTruck.id] == 'Open'
                                ? Colors.green
                                : Colors.red,
                            fontSize: 16),
                      )
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        foodTruck.description,
                        style: const TextStyle(
                            fontSize: 12), // Diminuer la taille du texte
                      ),
                      const Spacer(),
                      RatingBarIndicator(
                        itemBuilder: (context, _) {
                          return const Icon(
                            Icons.star,
                            color: Colors.amber,
                          );
                        },
                        rating: foodTruck.rating?.toDouble() ?? 0.0,
                        itemSize: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Foodtruckprofil(foodtruckId: foodTruck.id);
                  }));
                },
                child: const Text('Détails')),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    foodTrucks = ApiService().fetchFoodTrucks();
    _fetchFoodTruckStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des food trucks'),
      ),
      body: FutureBuilder<List<Foodtruck>>(
        future: foodTrucks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun food truck trouvé.'));
          }

          List<Foodtruck> foodTrucks = snapshot.data!;

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nom du food truck',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onChanged: (value) => setState(() {
                          foodTrucks = foodTrucks
                              .where((foodTruck) => foodTruck.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.list),
                      color: Colors.blue,
                      iconSize: 50),
                ],
              ),
              Expanded(
                child: FlutterMap(
                  mapController: mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(50.8476, 4.3572),
                    maxZoom: 13.0,
                    initialZoom: 12.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                      // Plenty of other options available!
                    ),
                    MarkerLayer(
                      markers: markers,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
