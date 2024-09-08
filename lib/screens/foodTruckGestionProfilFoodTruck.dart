import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';

class Foodtruckgestionprofilfoodtruck extends StatefulWidget {
  const Foodtruckgestionprofilfoodtruck({super.key});

  @override
  State<Foodtruckgestionprofilfoodtruck> createState() =>
      _FoodtruckgestionprofilfoodtruckState();
}

class _FoodtruckgestionprofilfoodtruckState
    extends State<Foodtruckgestionprofilfoodtruck> {
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
        actions: [],
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
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                title: const Text('Salut Food Truck Owner',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                subtitle: const Text('Votre espace gestion compte',
                    style: TextStyle(fontSize: 20)),
                trailing: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/images/foodtruck.jpg'),
                    ),
                    Positioned(
                      bottom: 25,
                      right: 25,
                      child: CircleAvatar(
                          radius: 1,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add_a_photo))),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Itemdashboard(
                        color: Colors.orange,
                        icon: Icons.app_settings_alt,
                        title: 'Creer un food truck',
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/pageFormFoodTruckProfil');
                        }),
                    Itemdashboard(
                        color: Colors.blue,
                        icon: Icons.location_on,
                        title: 'Modifier votre food truck',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.green,
                        icon: Icons.list,
                        title: 'Voir votre food truck',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.red,
                        icon: Icons.close,
                        title: 'suprimer votre food truck',
                        onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
