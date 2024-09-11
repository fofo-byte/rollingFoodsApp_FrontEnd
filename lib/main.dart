import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckAdmin.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckGestionProfil.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckGestionProfilFoodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/homeCustomer.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/gestionFoodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionLocationOwner/homeProprio.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/pageFormAdminAccount.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/pageFormFoodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/signUpPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rolling Foods',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            surface: Colors.grey.shade200,
            onSurface: Colors.black,
            primary: Colors.blue,
            onPrimary: Colors.white),
        useMaterial3: true,
      ),
      home: const Loginpage(),
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/homeCustomer': (context) => const HomeCustomer(),
        '/homeProprio': (context) => const HomePropio(),
        '/foodTruckAdmin': (context) => const FoodTruckAdmin(),
        '/foodTruckGestionProfil': (context) => const Foodtruckgestionprofil(),
        '/pageFormFoodTruckProfil': (context) =>
            const Pageformfoodtruckprofil(),
        '/createAccountFoodTruckOwner': (context) =>
            const Pageformadminaccount(),
        '/foodTruckGestionProfilFoodTruck': (context) =>
            const Foodtruckgestionprofilfoodtruck(),
        '/gestionFoodTruck': (context) => const Gestionfoodtruck(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
