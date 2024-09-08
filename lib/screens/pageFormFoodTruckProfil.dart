import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:rolling_foods_app_front_end/enum/foodType.dart';
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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

  String _selectedFoodTypes = '';

  // Food types for dropdown
  // Food types for dropdown
  final List<MultiSelectItem<String>> _foodTypes = [
    MultiSelectItem("FAST_FOOD", "Fast Food"),
    MultiSelectItem("Mexican", "Mexican"),
    MultiSelectItem("Italian", "Italian"),
    MultiSelectItem("Chinese", "Chinese"),
    MultiSelectItem("Japanese", "Japanese"),
    MultiSelectItem("Indian", "Indian"),
    MultiSelectItem("Mediterranean", "Mediterranean"),
    MultiSelectItem("American", "American"),
  ];

  // Method to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Retrieve user credential ID from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userCredentialId = prefs.getInt('id') ?? 0;

      if (userCredentialId != 0) {
        // Call your backend service to create the food truck
        ApiService().createFoodTruck(
          name: _nameController.text,
          description: _descriptionController.text,
          speciality: _specialityController.text,
          foodTypes: _selectedFoodTypes,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Food Truck created successfully!'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/foodTruckAdmin');
      } else {
        print("User credential ID not found.");
      }
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MultiSelectDialogField(
                    items: _foodTypes,
                    title: const Text("Food Types"),
                    selectedColor: Colors.blue,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    buttonText: Text(
                      "Select Food Types",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 16,
                      ),
                    ),
                    onConfirm: (results) {
                      setState(() {
                        _selectedFoodTypes = results
                            .map((result) => result.toString())
                            .join(',');
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Create Food Truck'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
