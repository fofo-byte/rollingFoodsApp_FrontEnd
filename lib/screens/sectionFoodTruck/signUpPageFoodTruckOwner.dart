import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rolling_foods_app_front_end/screens/sectionAuthentification/loginPage.dart';
import 'package:rolling_foods_app_front_end/services/user_service_API.dart';

class Signuppagefoodtruckowner extends StatefulWidget {
  const Signuppagefoodtruckowner({super.key});

  @override
  State<Signuppagefoodtruckowner> createState() =>
      _SignuppagefoodtruckownerState();
}

class _SignuppagefoodtruckownerState extends State<Signuppagefoodtruckowner> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      UserServiceApi().registerFoodTruckOwner(username, email, password);
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('You have successfully signed up'),
              content: const Text(
                  'Vous pouvez maintenant vous reconnecter et créer votre compte food trucker'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Loginpage()));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WARNING : Vous devez creer un compte food trucker',
              style: TextStyle(color: Colors.red)),
        ),
      );
    }
  }

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Icon(
                  FontAwesomeIcons.peopleGroup,
                  size: 100,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const ListTile(
                      title: Center(
                        child: Text(
                          'Vous êtes un FoodTrucker',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        "Rejoignez notre communauté de food truckers et faites découvrir vos délicieuses spécialités à des milliers de gourmands ! Créez votre compte dès aujourd'hui pour gérer facilement votre food truck, attirer de nouveaux clients et partager votre passion culinaire.",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontFamily: 'OpenSans'),
                      ),
                    ),
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
                            return 'Please enter a username';
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
                            return 'Please enter an email';
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
                            return 'Please enter a password';
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
                onPressed: () {
                  _signUp();
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
