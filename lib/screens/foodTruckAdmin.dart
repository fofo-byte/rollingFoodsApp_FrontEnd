import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';
import 'package:slide_to_act/slide_to_act.dart';

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
            child: Column(
              children: [
                SlideAction(
                  innerColor: Colors.orange,
                  outerColor: Colors.green,
                  sliderButtonIcon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onSubmit: () {},
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
                        icon: Icons.person,
                        title: 'Votre profil food truck',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.blue,
                        icon: Icons.location_on,
                        title: 'Liste des emplacements',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.green,
                        icon: Icons.list,
                        title: 'Historique des emplacements',
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
