import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/firebase_options.dart';
import 'package:rolling_foods_app_front_end/screens/sectionArticle/articleGestionHome.dart';
import 'package:rolling_foods_app_front_end/screens/sectionArticle/pageAddArticle.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rolling Foods',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE5E5E5),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
        iconTheme: const IconThemeData(color: Colors.white),
        dividerColor: Colors.white54,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
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
        '/addArticle': (context) => const Pageaddarticle(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
