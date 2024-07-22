import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/model/foodTruck.dart';
import 'package:http/http.dart' as http;
import 'package:rolling_foods_app_front_end/services/foodTruck_service.dart';



class HomeCustomer extends StatefulWidget {
  const HomeCustomer({super.key});

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  late Future<List<Foodtruck>> foodTrucks;

  @override
  void initState() {
    super.initState();
    foodTrucks = ApiService().fetchFoodTrucks();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text('Rolling Foods', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontFamily: 'Open Sans', letterSpacing: 2.0),
      ),
    ),
    body: Center(
      child: FutureBuilder<List<Foodtruck>>(
        future: foodTrucks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].description),
                );
              },
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    ),
    );
  }
}
