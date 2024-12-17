import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/favoritesPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/profilPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/searchPageMap.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/searchResultPage.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:rolling_foods_app_front_end/widgets/cardsWidget.dart';
import 'package:rolling_foods_app_front_end/widgets/iconsWidgetHome.dart';

class HomeCustomer extends StatefulWidget {
  const HomeCustomer({super.key});

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  final String? photoUrl = FirebaseAuth.instance.currentUser!.photoURL;

  String username = '';

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Liste des pages associées aux onglets de la BottomNavigationBar
  final List<Widget> _pages = [
    const HomeCustomerPage(),
    const Searchpagemap(),
    const Favoritespage(),
    const Profilpage(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text(
              'Hello Foods',
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: 'InriaSans',
              ),
            ),
          ],
        ),
        actions: [
          Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Rechercher',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.red),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                  ? NetworkImage(photoUrl!)
                  : const AssetImage('assets/images/user.png') as ImageProvider,
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeCustomerPage extends StatefulWidget {
  const HomeCustomerPage({super.key});

  @override
  State<HomeCustomerPage> createState() => _HomeCustomerPageState();
}

class _HomeCustomerPageState extends State<HomeCustomerPage> {
  late Future<List<Foodtruck>> foodTrucks;
  late Future<List<Foodtruck>> popularFoodTrucks;
  late Future<Map<String, dynamic>> _futureLocationAndFoodTrucks;
  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.denied;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    foodTrucks = ApiService().fetchFoodTrucks();
    popularFoodTrucks = ApiService().fetchFoodTrucks();
    _futureLocationAndFoodTrucks = _getLocationAndFoodTrucks(null);
  }

  Future<void> _getCurrentLocation() async {
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

    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _currentPosition = position;
    });
  }

  Future<Map<String, dynamic>> _getLocationAndFoodTrucks(
      String? foodType) async {
    // Récupérer à la fois la position actuelle et la liste des food trucks
    await _getCurrentLocation();
    List<Foodtruck> trucks = await ApiService().fetchFoodTrucks();

    print(
        'Liste brute des food trucks : ${trucks.map((e) => e.toJson()).toList()}');

    List<Map<String, dynamic>> foodTrucksWithDistance =
        await filterAndSortFoodTrucks(trucks, _currentPosition!);
    return {
      'position': _currentPosition,
      'trucks': foodTrucksWithDistance,
    };
  }

  Future<void> _filterFoodTrucks(String foodType) async {
    try {
      // Récupérer les food trucks par type
      List<Foodtruck> foodTrucks =
          await ApiService().getFoodTrucksByIconFilter(foodType);

      // Ajouter la distance à chaque food truck
      List<Map<String, dynamic>> trucksWithDistance = foodTrucks.map((truck) {
        double distance = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              truck.coordinates!.latitude,
              truck.coordinates!.longitude,
            ) /
            1000; // Conversion en kilomètres

        return {
          'foodTruck': truck,
          'distance': distance,
        };
      }).toList();

      trucksWithDistance.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
      );

      // Mettre à jour l'état avec la liste filtrée
      setState(() {
        _futureLocationAndFoodTrucks = Future.value({
          'position': _currentPosition,
          'trucks': trucksWithDistance,
        });
      });
    } catch (e) {
      print('Erreur lors du filtrage des food trucks : $e');
    }
  }

  Future<void> _searchFoodTrucks(String search) async {
    try {
      List<Foodtruck> newfoodTrucks =
          await ApiService().searchFoodTrucks(search);

      if (newfoodTrucks.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsPage(
              foodTrucks: newfoodTrucks,
              currentPosition: _currentPosition!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucun food truck trouvé'),
          ),
        );
      }
    } catch (e) {
      print('Failed to search food trucks: $e');
      throw Exception('Failed to search food trucks');
    }
  }

  //Filter Food Trucks disance and open
  Future<List<Map<String, dynamic>>> filterAndSortFoodTrucks(
      List<Foodtruck> foodTrucks, Position position) async {
    print('Position actuelle : ${position.latitude}, ${position.longitude}');
    print(
        'Food trucks initiaux : ${foodTrucks.map((e) => e.toJson()).toList()}');
    // Filtrer les food trucks ouverts et calculer la distance
    List<Map<String, dynamic>> foodTrucksWithDistance = foodTrucks
        .map((truck) {
          if (truck.coordinates == null) {
            print('Coordonnées du food truck non définies : ${truck.toJson()}');
            return null;
          }

          double distance = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                truck.coordinates!.latitude,
                truck.coordinates!.longitude,
              ) /
              1000;
          print(
              'Food truck ${truck.name}, distance : $distance km'); // Conversion en kilomètres
          return {
            'foodTruck': truck,
            'distance': distance,
          };
        })
        .cast<Map<String, dynamic>>()
        .where((truck) =>
            truck != null &&
            truck['distance'] <= 20 && // Vérifie la distance en km
            truck['foodTruck'].open == true) // Vérifie la distance ≤ 5 km
        .toList();

    // Trier par distance croissante
    foodTrucksWithDistance.sort(
      (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
    );

    print('foodTrucksWithDistance: $foodTrucksWithDistance');

    return foodTrucksWithDistance;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un food truck ou un type de cuisine',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchFoodTrucks(value);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez entrer un terme de recherche'),
                    ),
                  );
                }
              }),
        ),
        //Section for search icons
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenWidth * 0.02),
          child: Iconswidgethome(iconFilter: (foodType) {
            _filterFoodTrucks(foodType);
          }),
        ),
        //Section for list food trucks
        const Text(
          textAlign: TextAlign.start,
          'Food Trucks à proximité',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: Colors.black,
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
          thickness: 0.5,
        ),
        Expanded(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _futureLocationAndFoodTrucks,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (!snapshot.hasData ||
                    snapshot.data!['trucks'].isEmpty) {
                  return const Center(
                      child: Text('Aucun food truck trouvé autour de vous',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center));
                }

                print('Liste des food trucks: ${snapshot.data!['trucks']}');

                List<Map<String, dynamic>> trucksWithDistance =
                    snapshot.data!['trucks'];

                return ListView.builder(
                  itemCount: trucksWithDistance.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final truck = trucksWithDistance[index]['foodTruck'];
                    final distanceKm = trucksWithDistance[index]['distance'];

                    return FoodTruckCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Foodtruckprofil(
                              foodtruckId: truck.id,
                            ),
                          ),
                        );
                      },
                      name: truck.name,
                      description: truck.description,
                      rating:
                          truck.rating != null ? truck.rating!.toDouble() : 0.0,
                      imageUrl: (truck.urlProlfileImage != null &&
                              truck.urlProlfileImage!.isNotEmpty)
                          ? truck.urlProlfileImage!
                          : 'assets/images/foodtruck.jpg',

                      distance: '${distanceKm.toStringAsFixed(2)} km',
                      // Placeholder image
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
