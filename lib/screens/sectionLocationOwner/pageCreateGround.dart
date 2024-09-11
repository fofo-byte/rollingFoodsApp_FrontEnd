import 'package:flutter/material.dart';

class CreateGround extends StatelessWidget {
  const CreateGround({super.key});

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Page de création de lieux d'emplacements"),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  counterStyle: TextStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  labelText: 'Nom du lieu',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  counterStyle: TextStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  labelText: 'Adresse',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  counterStyle: TextStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const ElevatedButton(
                onPressed: null,
                child: Text('Créer un lieux d\'emplacement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
