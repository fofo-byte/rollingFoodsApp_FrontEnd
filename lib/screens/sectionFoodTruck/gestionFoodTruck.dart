import 'dart:core';

import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/screens/sectionArticle/articleGestionHome.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Gestionfoodtruck extends StatefulWidget {
  const Gestionfoodtruck({super.key});

  @override
  State<Gestionfoodtruck> createState() => _GestionfoodtruckState();
}

class _GestionfoodtruckState extends State<Gestionfoodtruck> {
  String username = '';
  int userId = 0;
  int foodTruckOwnerId = 0;
  int foodTruckId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tempUsername = prefs.getString('username') ?? 'Guest';
    int tempUserId = prefs.getInt('id') ?? 0;
    int tempFoodTruckOwnerId = 0;
    int tempFoodTruckId = 0;

    if (tempUserId != 0) {
      tempFoodTruckOwnerId = await _findIdFoodTruckOwner(tempUserId);
      tempFoodTruckId = await _findIdFoodTruck(tempFoodTruckOwnerId);
    }

    setState(() {
      username = tempUsername;
      userId = tempUserId;
      foodTruckOwnerId = tempFoodTruckOwnerId;
      foodTruckId = tempFoodTruckId;
    });

    print('foodTruckId: $foodTruckId');
  }

  Future<int> _findIdFoodTruckOwner(int userCredentialId) async {
    return await ApiService().findIdFoodTruckOwner(userCredentialId);
  }

  Future<int> _findIdFoodTruck(int foodTruckIdOwner) async {
    return await ApiService().getFoodTruckIdByOwnerId(foodTruckIdOwner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/foodTruckAdmin');
          },
        ),
        actions: const [],
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          'Hello Foods',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: foodTruckId == 0
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 100,
                ),
                ListTile(
                  title: Text('$username',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Votre espace gestion food truck',
                      style: TextStyle(fontSize: 20)),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                              title: 'Gestion profil food truck',
                              onTap: () {
                                Navigator.pushNamed(context,
                                    '/foodTruckGestionProfilFoodTruck');
                              }),
                          Itemdashboard(
                              color: Colors.blue,
                              icon: Icons.list,
                              title: 'Gestion articles',
                              onTap: () {
                                if (foodTruckId != 0) {
                                  print('Food truck id: $foodTruckId');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArticleGestionHome(
                                          foodtruckId: foodTruckId),
                                    ),
                                  );
                                } else {
                                  print('Food truck id is 0');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Veuillez attendre que le id food truck soit chargé'),
                                    ),
                                  );
                                }
                              }),
                          Itemdashboard(
                              color: Colors.grey,
                              icon: Icons.inventory,
                              title: 'Gestion stock',
                              onTap: () {}),
                          Itemdashboard(
                            color: Colors.grey,
                            icon: Icons.calculate,
                            title: 'Gestion ventes',
                            onTap: () async {},
                          ),
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
