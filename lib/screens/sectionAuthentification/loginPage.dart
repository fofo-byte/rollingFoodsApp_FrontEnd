import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rolling_foods_app_front_end/screens/sectionCustomer/homeCustomer.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/signUpPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/foodTruckAdmin.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/signUpPageFoodTruckOwner.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:rolling_foods_app_front_end/services/user_service_API.dart';
import 'package:rolling_foods_app_front_end/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        // Effacer toutes les données dans SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        User user = await UserServiceApi().loginUser(username, email, password);

        prefs.setString('token', user.token);
        prefs.setString('role', user.role);
        prefs.setInt('id', user.id);
        prefs.setBool('enabled', user.enabled);

        String? role = prefs.getString('role');
        int? id = prefs.getInt('id');
        bool? enabled = prefs.getBool('enabled');
        print('Token: ${user.token}');
        print('Role: ${user.role}');
        print('Id: ${user.enabled}');
        print('Role: $role');
        print('Id: $id');

        print('Enabled: $enabled');

        if (role == 'ROLE_USER') {
          // Redirection vers la page client
          Navigator.pushReplacementNamed(context, '/homeCustomer');
        } else if (role == 'ROLE_FOOD_TRUCK_OWNER') {
          if (enabled == false) {
            // Vérification si l'utilisateur est un FoodTruckOwner
            bool isFoodTruckOwner =
                await UserServiceApi().isFoodTruckOwner(id!);
            print('isFoodTruckOwner: $isFoodTruckOwner');
            if (isFoodTruckOwner) {
              //Show message if the user is not activated
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Compte non activé'),
                    content: const Text(
                        'Votre compte est verifié et un email vous sera envoyé après verification.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              // Redirection vers la page de formulaire d'inscription
              Navigator.pushReplacementNamed(
                  context, '/createAccountFoodTruckOwner');
            }
          } else {
            // Affichage de l'alerte si l'utilisateur n'est pas activé
            Navigator.pushReplacementNamed(context, '/foodTruckAdmin');
          }
        }
      } catch (e) {
        print('Failed to login user: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.jpeg'),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Vous étes un food trucker?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Signuppagefoodtruckowner()));
                            },
                            child: const Text('Cliquer ici'),
                          ),
                          const Text("Vous étes un lieux d'emplacement?"),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Cliquer ici'),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
