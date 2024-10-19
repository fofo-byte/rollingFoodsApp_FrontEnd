import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/signUpPage.dart';
import 'package:rolling_foods_app_front_end/screens/sectionFoodTruck/signUpPageFoodTruckOwner.dart';
import 'package:rolling_foods_app_front_end/services/user_service_API.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // S'assurer que l'utilisateur est déconnecté avant d'essayer de se connecter
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        print('Existing Google session signed out before sign-in attempt.');
      }

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print('Google sign-in aborted.');
        return; // L'utilisateur a annulé la connexion
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //Obtenir id et token d'authentification de Google
      final String? idToken = googleSignInAuthentication.idToken;
      print('IdToken: $idToken');

      //Envoyer les informations d'authentification au backend
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8686/api/auth'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'idToken': idToken!,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String jwtToken = data['token'];
        print('JWT Token: $jwtToken');

        //Enregistrer le token dans les Shared Preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', jwtToken);
        try {
          // Étape 1 : Normaliser le token JWT (partie payload)
          String base64Payload = base64.normalize(jwtToken.split(".")[1]);
          print('Base64 Payload: $base64Payload');

          // Étape 2 : Décoder en Base64
          String decodedPayload = utf8.decode(base64.decode(base64Payload));
          print('Decoded Payload: $decodedPayload');

          // Étape 3 : Convertir en JSON
          Map<String, dynamic> payload = json.decode(decodedPayload);
          print('Payload: $payload');
          // Sauvegarder les données seulement si elles existent
          prefs.setString(
              'role',
              payload['roles']?[0]?['authority'] ??
                  'Unknown'); // Accès correct au rôle
          prefs.setInt('id', payload['id'] ?? 0); // id
          prefs.setBool('enabled', payload['enabled'] ?? false); // enabled
          prefs.setString('email', payload['email'] ?? ''); // email
          prefs.setString('name', payload['username'] ?? ''); // username

// Gérer les valeurs nulles pour photoUrl (inexistante dans le payload)
          if (payload.containsKey('photoUrl') && payload['photoUrl'] != null) {
            prefs.setString('photoUrl', payload['photoUrl']);
          } else {
            print('photoUrl is null or not available in the payload');
          }

          print('idUser: ${payload['id']}');
          print('role: ${payload['roles']}');
          print('enabled: ${payload['enabled']}');
          print('email: ${payload['email']}');
          print('name: ${payload['username']}');
        } catch (e) {
          print('Failed to decode JWT token: $e');
        }

        // Redirection vers la page d'accueil
        String? role = prefs.getString('role');
        if (role == 'ROLE_USER') {
          Navigator.pushReplacementNamed(context, '/homeCustomer');
        } else {
          AlertDialog(
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
        }
      } else {
        print('Failed to sign in with Google');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = authResult.user;
      if (user != null) {
        print('Successfully signed in with Google');
        print('User: ${user.displayName}');
        print('User: ${user.email}');
        if (user.photoURL != null) {
          print('User: ${user.photoURL}');
        } else {
          print('No photo URL available');
          var photoUrl = Image.asset('assets/icons/icons8-person-64.png');
        }
      } else {
        print('Failed to sign in with Google');
      }
    } catch (e) {
      print('Failed to sign in with Google: $e');
    }
  }

  Future<void> _login() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        // Effacer toutes les données dans SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        var user = await UserServiceApi().loginUser(email, password);

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

  void _toggleVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(),
                    child: Lottie.asset('assets/animations/hello.json',
                        repeat: true,
                        reverse: true,
                        animate: true,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill),
                  ),
                  const Text(
                    'FOODS',
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenWidth * 0.02),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenWidth * 0.02),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: _toggleVisibility,
                                icon: _obscurePassword
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            obscureText: _obscurePassword,
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
                  const SizedBox(height: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenWidth * 0.02),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: ElevatedButton(
                        onPressed: _login,
                        child: const Text('Connexion'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text('Ou connectez-vous avec'),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon:
                            Image.asset('assets/icons/icons8-facebook-48.png'),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _signInWithGoogle();
                        },
                        icon: Image.asset('assets/icons/icons8-google-48.png'),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon:
                            Image.asset('assets/icons/icons8-instagram-48.png'),
                      ),
                    ],
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
                  const Center(
                    child: ListTile(
                      title: Text(
                        'Vous êtes un food trucker ou un emplacement?',
                        textAlign: TextAlign.center,
                      ),
                      subtitle:
                          Text('Créez un compte', textAlign: TextAlign.center),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Signuppagefoodtruckowner()));
                            },
                            icon: Image.asset(
                                'assets/icons/icons8-food-truck-48.png'),
                          ),
                          const Text('Food trucker'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/signUpPageLocationOwner');
                            },
                            icon: const Icon(FontAwesomeIcons.mapLocationDot),
                          ),
                          const Text('Emplacement'),
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
