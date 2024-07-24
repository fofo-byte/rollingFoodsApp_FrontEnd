import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rolling_foods_app_front_end/widgets/map.dart';


class Foodtruckprofil extends StatefulWidget {

  const Foodtruckprofil({super.key});

  @override
  State<Foodtruckprofil> createState() => _FoodtruckprofilState();
}

class _FoodtruckprofilState extends State<Foodtruckprofil> {


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
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text('Rolling Foods', style: TextStyle(
            color: Colors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Lonely',
            letterSpacing: 2.0),
        ),
      ),
      body:   const SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              width: double.infinity,
              height: 280,
              child: Map(),
              ),
            Padding(
                padding: EdgeInsets.only(top: 250),
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage('assets/images/foodtruck.jpg'),
                ),
            ),
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 400),
                    child: Text(
                      "Foodtruck Name",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Description", style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87
                            )),
                            subtitle: Text("Description of the foodtruck"),
                          ),
                          ListTile(
                            title: Text("Location"),
                            subtitle: Text("Location of the foodtruck"),
                          ),
                          ListTile(
                            title: Text("Opening hours"),
                            subtitle: Text("Opening hours of the foodtruck"),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              ],
            )
          ],
        ),

      ),

    );
  }
}



