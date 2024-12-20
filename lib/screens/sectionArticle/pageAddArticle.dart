import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:rolling_foods_app_front_end/services/article_service.dart';

class Pageaddarticle extends StatefulWidget {
  const Pageaddarticle({super.key});

  @override
  State<Pageaddarticle> createState() => _PageaddarticleState();
}

class _PageaddarticleState extends State<Pageaddarticle> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedCategory = '';

  File? _image;
  final picker = ImagePicker();
  String? imageUrl;

  final List<MultiSelectItem<String>> _categories = [
    MultiSelectItem("PROMOTION", "Promotion"),
    MultiSelectItem("SPECIALITY", "Spécialité"),
    MultiSelectItem("NEW", "Nouveauté"),
  ];

  // Method to upload an image
  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Call the upload method after selecting the image
      if (_image != null) {
        if (imageUrl != null) {
          print("Image URL: $imageUrl");
        }
      }
    } else {
      print('No image selected.');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Call the createFoodTruck method
      await ArticleService().createArticle(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        itemCategorie: _selectedCategory,
        pictureItem: _image!,
      );

      // Show a dialog to confirm the creation of the food truck
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Article créé avec succès'),
            content: const Text('Votre article a été créé avec succès'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/gestionFoodTruck');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
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
      body: ListView(
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
                title: Text("Creation d'article",
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
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/images/foodtruck.jpg')
                              as ImageProvider,
                    ),
                    IconButton(
                      padding: EdgeInsets.all(80),
                      color: Colors.black,
                      onPressed: () async {
                        await getImage();
                      },
                      icon: const Icon(
                        FontAwesomeIcons.cameraRetro,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nom de l'article",
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
                      labelText: "Description de l'article",
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
                    controller: _priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Prix de l'article",
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un prix';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MultiSelectDialogField(
                    items: _categories,
                    title: const Text("Selectionner le Menu"),
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
                      "Menu",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 16,
                      ),
                    ),
                    onConfirm: (results) {
                      setState(() {
                        _selectedCategory = results
                            .map((result) => result.toString())
                            .join(',');
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Créer Article'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
