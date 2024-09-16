import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class FoodTruckAdmin extends StatefulWidget {
  const FoodTruckAdmin({super.key});

  @override
  State<FoodTruckAdmin> createState() => _FoodTruckAdminState();
}

class _FoodTruckAdminState extends State<FoodTruckAdmin> {
  String username = '';
  int foodtruckId = 0;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Loginpage()));
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
      foodtruckId = prefs.getInt('id') ?? 0;
    });
  }

  Future<void> _checkFoodTruckExists(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;
    int foodTruckOwnerId = await ApiService().findIdFoodTruckOwner(userId);

    try {
      int foodTruckId =
          await ApiService().getFoodTruckIdByOwnerId(foodTruckOwnerId);
      print('Food truck id flag: $foodTruckId'); // get the food truck id

      // ignore: unnecessary_null_comparison
      if (foodTruckId == 0) {
        // ignore: use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Vous n\'avez pas de food truck'),
              content: const Text('Voulez-vous créer un food truck?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Non'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/pageFormFoodTruckProfil');
                  },
                  child: const Text('Oui'),
                ),
              ],
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Gérer votre food truck'),
              content: const Text('Voulez-vous gérer votre food truck?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Non'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/gestionFoodTruck',
                        arguments: foodTruckId);
                  },
                  child: const Text('Oui'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous n\'avez pas de food truck'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      elevation: 10,
      backgroundColor: Colors.orange,
    );
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(children: [
              const SizedBox(
                height: 60,
              ),
              ListTile(
                title: Text('Salut $username ${foodtruckId.toString()}',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                subtitle: const Text('Bienvenue sur votre espace admin',
                    style: TextStyle(fontSize: 20)),
                trailing: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      _logout();
                    },
                  ),
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
                SlideAction(
                  innerColor: Colors.orange,
                  outerColor: Colors.green,
                  sliderButtonIcon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onSubmit: () {
                    return null;
                  },
                  height: 70,
                  text: 'Envoyer votre position',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        title: 'Gerez votre compte',
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/foodTruckGestionProfil');
                        }),
                    Itemdashboard(
                        color: Colors.blue,
                        icon: Icons.location_on,
                        title: 'Gerez votre foodtruck',
                        onTap: () {
                          _checkFoodTruckExists(context);
                        }),
                    Itemdashboard(
                        color: Colors.green,
                        icon: Icons.list,
                        title: 'Gerez les emplacements',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.red,
                        icon: Icons.close,
                        title: 'Fermer le food truck',
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
