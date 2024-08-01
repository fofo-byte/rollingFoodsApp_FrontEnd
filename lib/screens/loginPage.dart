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
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
