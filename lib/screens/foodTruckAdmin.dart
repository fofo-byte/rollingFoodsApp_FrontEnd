import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';

class FoodTruckAdmin extends StatefulWidget {
  const FoodTruckAdmin({super.key});

  @override
  State<FoodTruckAdmin> createState() => _FoodTruckAdminState();
}

class _FoodTruckAdminState extends State<FoodTruckAdmin> {
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
            child: const Column(children: [
              SizedBox(
                height: 60,
              ),
              ListTile(
                title: Text('salut admin',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                subtitle: Text('Bienvenue sur votre espace admin',
                    style: TextStyle(fontSize: 20)),
                trailing: CircleAvatar(
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
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                /*
                itemDashboard('Liste des camions', Icons.abc, Colors.red),
                itemDashboard(
                    'Liste des lieux', Icons.location_on, Colors.blue),
                itemDashboard(
                    'Liste des commandes', Icons.shopping_cart, Colors.green),
                itemDashboard('Liste des clients', Icons.people, Colors.purple),
                */

                Itemdashboard(
                    color: Colors.red,
                    icon: Icons.abc,
                    title: 'Créer un lieu d\'emplacement'),
                Itemdashboard(
                    color: Colors.blue,
                    icon: Icons.location_on,
                    title: 'Vos lieu d\'emplacement'),
                Itemdashboard(
                    color: Colors.green,
                    icon: Icons.shopping_cart,
                    title: 'Vos commandes'),
                Itemdashboard(
                    color: Colors.purple,
                    icon: Icons.people,
                    title: 'Vos clients'),
                Itemdashboard(
                    color: Colors.black,
                    icon: Icons.people,
                    title: 'Vos clients'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
