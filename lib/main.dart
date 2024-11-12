import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/firebase_options.dart';
import 'package:rolling_foods_app_front_end/screens/sectionArticle/pageAddArticle.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/forgotPassword.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/signUpPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/homeCustomer.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckAdmin.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckGestionProfil.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckGestionProfilFoodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/gestionFoodTruck.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/pageFormAdminAccount.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/pageFormFoodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/screens/sectionLocationOwner/homeProprio.dart';
import 'package:rolling_foods_app_front_end/screens/sectionLocationOwner/signUpPageLocationOwner.dart';
import 'package:rolling_foods_app_front_end/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rolling Foods',
      theme: rollingFoodsTheme,
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
        '/signUpPageLocationOwner': (context) =>
            const Signuppagelocationowner(),
        '/foodTruckGestionProfilFoodTruck': (context) =>
            const Foodtruckgestionprofilfoodtruck(),
        '/gestionFoodTruck': (context) => const Gestionfoodtruck(),
        '/addArticle': (context) => const Pageaddarticle(),
        '/forgotPassword': (context) => const ForgotPasswordPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
