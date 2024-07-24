import 'package:flutter/material.dart';
import 'package:rolling_foods_app_front_end/screens/foodTruckProfil.dart';
import 'package:rolling_foods_app_front_end/screens/homeCustomer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFF44336), // Rouge

        useMaterial3: true,
      ),
      home: const Foodtruckprofil(),
      debugShowCheckedModeBanner: false,
    );
  }
}


