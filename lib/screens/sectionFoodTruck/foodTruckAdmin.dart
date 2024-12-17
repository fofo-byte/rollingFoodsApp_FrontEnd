import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:geolocator/geolocator.dart';

class FoodTruckAdmin extends StatefulWidget {
  const FoodTruckAdmin({super.key});

  @override
  State<FoodTruckAdmin> createState() => _FoodTruckAdminState();
}

class _FoodTruckAdminState extends State<FoodTruckAdmin> {
  String username = '';
  int foodtruckId = 0;
  bool _isOpen = false;
  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.denied;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _checkFoodTruckStatus();
  }

  Future<Position> _getCurrentLocation() async {
    //Verify if the location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    //Get the current location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //Get the current location

    return await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _openFoodTruck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;
    int foodTruckOwnerId = await ApiService().findIdFoodTruckOwner(userId);

    try {
      int foodTruckId =
          await ApiService().getFoodTruckIdByOwnerId(foodTruckOwnerId);

      //Get the current location
      Position position = await _getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;

      //Update the food truck location
      await ApiService().openFoodTruck(foodTruckId, latitude, longitude);

      print('Food truck ouvert: $foodTruckId');
      // get the food truck id
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous n\'avez pas ouvert le food truck'),
        ),
      );
    }
  }

  //Close the food truck
  Future<void> _closeFoodTruck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;
    int foodTruckOwnerId = await ApiService().findIdFoodTruckOwner(userId);

    try {
      int foodTruckId =
          await ApiService().getFoodTruckIdByOwnerId(foodTruckOwnerId);

      //Update the food truck location
      await ApiService().closeFoodTruck(foodTruckId);

      print('Food truck fermé: $foodTruckId');
      // get the food truck id
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous n\'avez pas fermé le food truck'),
        ),
      );
    }
  }

  //Find food truck status
  Future<bool> _findFoodTruckStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;
    int foodTruckOwnerId = await ApiService().findIdFoodTruckOwner(userId);

    try {
      int foodTruckId =
          await ApiService().getFoodTruckIdByOwnerId(foodTruckOwnerId);
      bool isOpen = await ApiService().getFoodTruckStatus(foodTruckId);

      return isOpen;
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pas de statut de food truck trouvé'),
        ),
      );
      return false;
    }
  }

  //Check food truck status
  Future<void> _checkFoodTruckStatus() async {
    bool isOpen = await _findFoodTruckStatus();
    setState(() {
      _isOpen = !isOpen;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const Loginpage();
    }));
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
    double screenWidth = MediaQuery.of(context).size.width;
    ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      elevation: 10,
      backgroundColor: Colors.orange,
    );
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.03),
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(300),
              ),
            ),
            child: Column(children: [
              const SizedBox(
                height: 60,
              ),
              ListTile(
                title: const Text('Dashboard Hello Foods',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                subtitle: const Text('Espace Administrateur',
                    style: TextStyle(fontSize: 20)),
                trailing: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    tooltip: 'Déconnexion',
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
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
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      ' $username',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text('Status: ${_isOpen ? 'Fermé' : 'Ouvert'}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SlideAction(
                  innerColor: _isOpen ? Colors.orange : Colors.orange,
                  outerColor: _isOpen ? Colors.green : Colors.red,
                  sliderButtonIcon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onSubmit: () async {
                    if (!_isOpen) {
                      // Si le food truck est ouvert, on le ferme
                      await _closeFoodTruck();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Food truck fermé'),
                            content: const Text(
                                'Votre food truck est fermé, vous ne pouvez plus recevoir des commandes'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _checkFoodTruckStatus();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );

                      // Méthode pour fermer le food truck
                    } else {
                      // Si le food truck est fermé, on l'ouvre
                      await _openFoodTruck();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Food truck ouvert'),
                            content: const Text(
                                'Votre food truck est ouvert, vous pouvez maintenant recevoir des commandes'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _checkFoodTruckStatus();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      // Méthode pour ouvrir le food truck
                    }
                  },
                  height: 70,
                  text: _isOpen ? 'Ouvrir Food Truck' : 'Fermer Food Truck',
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: GridView(
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
                          icon: FontAwesomeIcons.gear,
                          title: 'Gerez votre compte',
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/foodTruckGestionProfil');
                          }),
                      Itemdashboard(
                          color: Colors.blue,
                          icon: FontAwesomeIcons.truckFast,
                          title: 'Gerez votre foodtruck',
                          onTap: () {
                            _checkFoodTruckExists(context);
                          }),
                      Itemdashboard(
                          color: Colors.grey,
                          icon: FontAwesomeIcons.locationDot,
                          title: 'Gerez les emplacements',
                          onTap: () {}),
                      Itemdashboard(
                          color: Colors.grey,
                          icon: FontAwesomeIcons.cartShopping,
                          title: "Gerez les commandes",
                          onTap: () {}),
                      Itemdashboard(
                          color: Colors.grey,
                          icon: Icons.analytics,
                          title: 'View Analytics',
                          onTap: () {}),
                      Itemdashboard(
                          color: Colors.grey,
                          icon: Icons.qr_code,
                          title: 'Lecteur de Qr_Code',
                          onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
