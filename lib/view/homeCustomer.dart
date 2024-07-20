import 'package:flutter/material.dart';



class HomeCustomer extends StatefulWidget {
  const HomeCustomer({super.key});

  @override
  State<HomeCustomer> createState() => _HomeCustomerState();
}

class _HomeCustomerState extends State<HomeCustomer> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text('Rolling Foods', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontFamily: 'Open Sans', letterSpacing: 2.0),
      ),
    ),
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to Rolling Foods',
          ),
        ],
      ),
    ),
    );
  }
}
