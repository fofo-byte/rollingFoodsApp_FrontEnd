import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/screens/sectionArticle/pageAddArticle.dart';
import 'package:rolling_foods_app_front_end/screens/sectionArticle/pageListArticle.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleGestionHome extends StatefulWidget {
  const ArticleGestionHome({super.key, required int foodtruckId});

  @override
  State<ArticleGestionHome> createState() => _ArticleGestionHomeState();
}

class _ArticleGestionHomeState extends State<ArticleGestionHome> {
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
              padding: EdgeInsets.all(screenWidth * 0.05),
              children: [
                const SizedBox(
                  height: 50,
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
                              color: Colors.blue,
                              icon: Icons.add,
                              title: 'Ajouter un article',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Pageaddarticle()));
                              }),
                          Itemdashboard(
                              color: Colors.green,
                              icon: Icons.list,
                              title: 'Modifier article',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Pagelistarticle()));
                              }),
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
