import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.red,
        title: const Text('Rolling Foods', style: TextStyle(
            color: Colors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Open Sans',
            letterSpacing: 2.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.red,
              height: 150,
              child: const Center(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.red,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for food trucks',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Food Trucks à proximité',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
            ),
            FutureBuilder<List<Foodtruck>>(
              future: foodTrucks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Foodtruck>? data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.deepPurple,
                        child: ListTile(
                          textColor: Colors.yellow,
                          title: Text(data[index].name),
                          subtitle: Text(data[index].description),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

}