import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/screens/foodTruckAdmin.dart';
import 'package:rolling_foods_app_front_end/screens/foodTruckGestionProfil.dart';
import 'package:rolling_foods_app_front_end/screens/foodTruckGestionProfilFoodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/foodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/screens/homeCustomer.dart';
import 'package:rolling_foods_app_front_end/screens/homeProprio.dart';
import 'package:rolling_foods_app_front_end/screens/loginPage.dart';
import 'package:rolling_foods_app_front_end/screens/pageFormAdminAccount.dart';
import 'package:rolling_foods_app_front_end/screens/pageFormFoodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/screens/signUpPage.dart';

void main() {
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
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
