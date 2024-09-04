import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiselect/multiselect.dart';

class Pageformfoodtruckprofil extends StatefulWidget {
  const Pageformfoodtruckprofil({super.key});

  @override
  State<Pageformfoodtruckprofil> createState() =>
      _PageformfoodtruckprofilState();
}

class _PageformfoodtruckprofilState extends State<Pageformfoodtruckprofil> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _foodTypeController = TextEditingController();
  File? _image;
  final List<File> _foodTruckImages = [];

  List<String> foodTypes = [];

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
        actions: [
          IconButton(
            color: Colors.yellow,
            icon: const Icon(Icons.account_circle),
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
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Column(children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text('Creation de votre profil FoodTruck',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                subtitle: Text('Remplir tous les champs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
            ]),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du Food Truck',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 3,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description du Food Truck',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _specialityController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Spécialité',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une spécialité';
                      }
                      return null;
                    },
                  ),
                ),
                const Text('Type de nourriture'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropDownMultiSelect(
                    selectedValuesStyle: const TextStyle(color: Colors.white),
                    options: const [
                      'Fast Food',
                      'Mexican',
                      'Italian',
                      'Chinese',
                      'Japanese',
                      'Indian',
                      'Mediterranean',
                      'American',
                      'French',
                      'Spanish',
                      'Greek',
                      'German',
                      'Korean',
                      'Thai',
                      'Vietnamese',
                      'Turkish',
                    ],
                    selectedValues: foodTypes,
                    whenEmpty: 'Aucun type de nourriture sélectionné',
                    onChanged: (List<String> values) {
                      setState(() {
                        foodTypes = values;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
