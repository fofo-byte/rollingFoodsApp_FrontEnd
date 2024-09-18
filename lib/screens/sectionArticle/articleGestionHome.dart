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
      body: foodTruckId == 0
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                Text('Bonjour $username'),
                Text('Votre id est $userId'),
                Text('Votre food truck id est $foodTruckId'),
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  child: Column(children: [
                    const SizedBox(
                      height: 50,
                    ),
                    ListTile(
                      title: Text('Salut $username',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Votre espace gestion articles',
                          style: TextStyle(fontSize: 20)),
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
                              title: 'Afficher liste articles',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Pagelistarticle()));
                              }),
                          Itemdashboard(
                              color: Colors.blue,
                              icon: Icons.draw,
                              title: 'Modifier article',
                              onTap: () {}),
                          Itemdashboard(
                            color: Colors.red,
                            icon: Icons.close,
                            title: 'Supprimer article',
                            onTap: () async {
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Voulez-vous vraiment supprimer votre food truck?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            false); // Renvoie "false" si l'utilisateur annule
                                      },
                                      child: const Text('Non'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            true); // Renvoie "true" si l'utilisateur confirme
                                      },
                                      child: const Text('Oui'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                try {
                                  await ApiService()
                                      .deleteFoodTruck(foodTruckId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Food truck supprimé avec succès!'),
                                    ),
                                  );
                                  Navigator.pushNamed(
                                      context, '/foodTruckGestionProfil');
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Erreur lors de la suppression du food truck.'),
                                    ),
                                  );
                                }
                              }
                            },
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
