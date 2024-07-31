import 'package:flutter/material.dart';

class FoodTruckAdmin extends StatefulWidget {
  const FoodTruckAdmin({super.key});

  @override
  State<FoodTruckAdmin> createState() => _FoodTruckAdminState();
}

class _FoodTruckAdminState extends State<FoodTruckAdmin> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      elevation: 10,
      backgroundColor: Colors.orange,
    );
    return Scaffold(
      appBar: AppBar(
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
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Page d'administration du foodtruck"),
              ElevatedButton(
                onPressed: null,
                child: Text('Foodtruck ouvert'),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text("Liste des lieux d'emplacements"),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('Administation foodtruck'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
