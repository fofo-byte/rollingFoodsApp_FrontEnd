import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/avd.dart';
import 'package:latlong2/latlong.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service.dart';
import 'package:rolling_foods_app_front_end/widgets/map.dart';

class Foodtruckprofil extends StatefulWidget {
  final int foodtruckId;

  const Foodtruckprofil({super.key, required this.foodtruckId});

  @override
  State<Foodtruckprofil> createState() => _FoodtruckprofilState();
}

class _FoodtruckprofilState extends State<Foodtruckprofil> {
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
            future: ApiService().fetchFoodTruckById(widget.foodtruckId),
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
              return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(foodtruck.name,
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 16),
                      Text(foodtruck.description),
                    ],
                  ));
            }));
  }
}
