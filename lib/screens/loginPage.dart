import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Text('Login Page'),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Username',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/homeCustomer');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
