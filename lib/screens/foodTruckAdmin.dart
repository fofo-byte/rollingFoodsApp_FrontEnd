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
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: Icon(Icons.account_circle),
            onPressed: () {

            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text('Rolling Foods', style: TextStyle(
            color: Colors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Lonely',
            letterSpacing: 2.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
              ElevatedButton(
                  onPressed: null,
                  child: Text('Foodtruck ouvert'),
              ),
              ElevatedButton(
                  onPressed: null,
                  child: Text('Voir les terrains'),
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
