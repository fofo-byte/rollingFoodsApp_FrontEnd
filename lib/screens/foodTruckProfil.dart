import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:rolling_foods_app_front_end/widgets/map.dart';

class Foodtruckprofil extends StatefulWidget {
  final int foodtruckId;

  const Foodtruckprofil({super.key, required this.foodtruckId});

  @override
  State<Foodtruckprofil> createState() => _FoodtruckprofilState();
}

class _FoodtruckprofilState extends State<Foodtruckprofil> {
  late Future<Foodtruck> foodTruck;
  final MapController _mapController = MapController();

  final List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    foodTruck = ApiService().fetchFoodTruckById(widget.foodtruckId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              color: Colors.yellow,
              icon: const Icon(Icons.account_circle),
              onPressed: () {},
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.teal,
          title: const Text(
            'Rolling Foods',
            style: TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'Lonely',
                letterSpacing: 2.0),
          ),
        ),
        body: FutureBuilder<Foodtruck>(
            future: foodTruck,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data'));
              }
              Foodtruck foodtruck = snapshot.data!;

              markers.add(Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(foodtruck.coordinates.latitude,
                    foodtruck.coordinates.longitude),
                child: const Icon(Icons.pin_drop, color: Colors.red),
              ));

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          maxZoom: 15,
                          initialCenter: LatLng(foodtruck.coordinates.latitude,
                              foodtruck.coordinates.longitude),
                          initialZoom: 14,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                            // Plenty of other options available!
                          ),
                          MarkerLayer(
                            markers: markers,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10, vertical: 0),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage("assets/images/foodtruck.jpg"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodtruck.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            foodtruck.foodTypes,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            foodtruck.description,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            foodtruck.speciality,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
