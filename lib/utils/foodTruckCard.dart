import'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/model/foodTruck.dart';



class Foodtruckcard extends StatelessWidget {
  const Foodtruckcard({super.key, required this.foodtruck});

  final Foodtruck foodtruck;



  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(foodtruck.name),
            subtitle: Text(foodtruck.description),
          ),
        ],
      ),
    );
  }
}

