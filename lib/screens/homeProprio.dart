import 'package:flutter/material.dart';

class HomePropio extends StatefulWidget {
  const HomePropio({super.key});

  @override
  State<HomePropio> createState() => _HomePropioState();
}

class _HomePropioState extends State<HomePropio> {
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
              Text("Page du proprio de lieu d'emplacement"),
              ElevatedButton(
                onPressed: null,
                child: Text('Voir la liste de lieux d\'emplacement'),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('Modifier profil'),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('Administation lieu d\'emplacement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
