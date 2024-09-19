import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCustomer extends StatefulWidget {
  const HomeCustomer({super.key});

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  final String? photoUrl = FirebaseAuth.instance.currentUser!.photoURL;
  String username = '';
  late Future<List<Foodtruck>> foodTrucks;
  late Future<List<Foodtruck>> popularFoodTrucks;

  @override
  void initState() {
    super.initState();
    foodTrucks = ApiService().fetchFoodTrucks();
    popularFoodTrucks = ApiService().fetchFoodTrucks();
    _loadUsername();
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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Loginpage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Text(
              'Rolling Foods',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Lonely',
                  letterSpacing: 2.0),
            ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Bonjour $username',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            //Section for search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              width: 400,
              margin: const EdgeInsets.all(10),
              child: const Center(
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for food trucks',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //Section for list food trucks
            const Text(
              textAlign: TextAlign.center,
              'A proximité',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const Divider(
              height: 1,
              color: Colors.grey,
              thickness: 0.5,
            ),
            FutureBuilder<List<Foodtruck>>(
              future: foodTrucks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Foodtruck> data = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 5,
                        shadowColor: Colors.black,
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          //leading: Image.network(data[index].image),
                          title: Text(data[index].name),
                          subtitle: Text(data[index].description),
                          leading: CircleAvatar(
                            backgroundImage: data[index].urlProlfileImage !=
                                    null
                                ? NetworkImage(data[index].urlProlfileImage!)
                                : const AssetImage(
                                    'assets/images/foodtruck.png'),
                          ),

                          //trailing: Text(data[index].location),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Foodtruckprofil(
                                    foodtruckId: data[index].id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Food Trucks les plus populaires',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
