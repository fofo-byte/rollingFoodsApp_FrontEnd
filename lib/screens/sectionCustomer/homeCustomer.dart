import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/favoritesPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/profilPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/searchPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckProfil.dart';
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
    const Searchpage(),
    const Favoritespage(),
    const Profilpage(),
  ];

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage:
                  photoUrl != null ? NetworkImage(photoUrl!) : null,
              child: photoUrl == null ? const Icon(Icons.person) : null,
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.red),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
    _futureLocationAndFoodTrucks = _getLocationAndFoodTrucks();
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

  Future<Map<String, dynamic>> _getLocationAndFoodTrucks() async {
    // Récupérer à la fois la position actuelle et la liste des food trucks
    await _getCurrentLocation();
    List<Foodtruck> trucks = await ApiService().fetchFoodTrucks();
    return {
      'position': _currentPosition,
      'trucks': trucks,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un food truck...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onChanged: (value) {
              // Add your search logic here
            },
          ),
        ),
        //Section for search icons
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: const Iconswidgethome(),
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
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No data found'));
                }

                Position position = snapshot.data!['position'];
                List<Foodtruck> data = snapshot.data!['trucks'];

                if (position == null) {
                  return const Center(child: Text('No position found'));
                }

                return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    double distance = Geolocator.distanceBetween(
                      position.latitude,
                      position.longitude,
                      data[index].coordinates!.latitude,
                      data[index].coordinates!.longitude,
                    );
                    double distanceKm = distance / 1000;

                    return FoodTruckCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Foodtruckprofil(
                              foodtruckId: data[index].id,
                            ),
                          ),
                        );
                      },
                      name: data[index].name,
                      description: data[index].description,
                      rating: data[index].rating != null
                          ? data[index].rating!.toDouble()
                          : 0.0,
                      imageUrl: data[index].urlProlfileImage != null
                          ? data[index].urlProlfileImage!
                          : 'https://via.placeholder.com/150',
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
