import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/favoritesPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/profilPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/searchPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:rolling_foods_app_front_end/widgets/iconsWidgetHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rolling_foods_app_front_end/widgets/cardsWidget.dart';

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
    _loadUsername();
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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Loginpage()));
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername != null) {
      setState(() {
        username = savedUsername;
      });
    } else {
      setState(() {
        username = FirebaseAuth.instance.currentUser!.displayName!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text(
              'Rolling Foods',
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: 'InriaSans',
              ),
            ),
            /*
            Text(
              username,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'Lonely',
                letterSpacing: 2.0,
              ),
            ),
            */
          ],
        ),
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: Image.network(photoUrl!),
            onPressed: () {
              _logout();
            },
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
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
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

  @override
  void initState() {
    super.initState();
    foodTrucks = ApiService().fetchFoodTrucks();
    popularFoodTrucks = ApiService().fetchFoodTrucks();
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
              prefixIcon: Icon(Icons.search),
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
          child: FutureBuilder<List<Foodtruck>>(
            future: foodTrucks,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Foodtruck> data = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
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
                      icon: Icons.location_on,
                      imageUrl: data[index].urlProlfileImage != null
                          ? data[index].urlProlfileImage!
                          : 'https://via.placeholder.com/150',
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
