import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/services/user_service_API.dart';
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

  Future<void> _logout() async {
    // Effacer toutes les données de session de l'application
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Local data cleared.');

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Loginpage()));
  }

  //Delete account
  Future<void> _deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? UserCredentialId = prefs.getInt('id');
    try {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Supprimer le compte'),
              content: const Text(
                  'Êtes-vous sûr de vouloir supprimer votre compte ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () async {
                    UserServiceApi().deleteAccount(UserCredentialId!);
                    await _logout();
                  },
                  child: const Text('Confirmer'),
                ),
              ],
            );
          });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/foodTruckAdmin');
          },
        ),
        actions: const [],
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          'Hello Foods',
          style: TextStyle(
            color: Colors.black,
            fontSize: 50,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
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
                height: 10,
              ),
              ListTile(
                title: Text('$username ${foodtruckId.toString()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                subtitle: const Text('Votre espace gestion de compte',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),
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
                        color: Colors.blue,
                        icon: Icons.upgrade,
                        title: 'Modifier votre compte',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.red,
                        icon: Icons.close,
                        title: 'Supprimer votre compte',
                        onTap: _deleteAccount),
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
