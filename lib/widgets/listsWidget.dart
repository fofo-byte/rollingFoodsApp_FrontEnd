import 'package:flutter/material.dart';

class ListsWidget extends StatelessWidget {
  String name;
  String category;

  ListsWidget({
    required this.name,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/foodtruck.jpg'),
            ),
            title: Text(name),
            subtitle: Text(category),
          ),
        ],
      ),
    );
  }
}
