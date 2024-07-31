import 'package:flutter/material.dart';

class ListGround extends StatefulWidget {
  const ListGround({super.key});

  @override
  State<ListGround> createState() => _ListGroundState();
}

class _ListGroundState extends State<ListGround> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Rolling Foods',
          style: TextStyle(
              color: Colors.yellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: 'Lonely',
              letterSpacing: 2.0),
        ),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Page de la liste des lieux d'emplacements"),
            ],
          ),
        ),
      ),
    );
  }
}
