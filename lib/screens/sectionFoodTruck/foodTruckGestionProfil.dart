import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Foodtruckgestionprofil extends StatefulWidget {
  const Foodtruckgestionprofil({super.key});

  @override
  State<Foodtruckgestionprofil> createState() => _FoodtruckgestionprofilState();
}

class _FoodtruckgestionprofilState extends State<Foodtruckgestionprofil> {
  String username = '';
  int foodtruckId = 0;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
      foodtruckId = prefs.getInt('id') ?? 0;
    });
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
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
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
                title: Text('$username ${foodtruckId.toString()}',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                subtitle: const Text('Votre espace gestion compte',
                    style: TextStyle(fontSize: 20)),
                trailing: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/foodtruck.jpg'),
                  radius: 30,
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
                        title: 'Creer un compte',
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/createAccountFoodTruckOwner');
                        }),
                    Itemdashboard(
                        color: Colors.blue,
                        icon: Icons.upgrade,
                        title: 'Modifier votre compte',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.red,
                        icon: Icons.close,
                        title: 'Supprimer votre compte',
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
