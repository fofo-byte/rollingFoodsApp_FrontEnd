import 'package:flutter/material.dart';
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
        colorScheme: ColorScheme.light(
            surface: Colors.grey.shade200,
            onSurface: Colors.black,
            primary: Colors.blue,
            onPrimary: Colors.white),
        useMaterial3: true,
      ),
      home: const HomeCustomer(),
      debugShowCheckedModeBanner: false,
    );
  }
}
