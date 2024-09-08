import 'dart:ffi';
import 'dart:io';
import 'dart:core';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rolling_foods_app_front_end/services/firebaseService.dart';
import 'package:rolling_foods_app_front_end/widgets/itemDashboard.dart';
import 'package:path/path.dart' as path;

class Foodtruckgestionprofilfoodtruck extends StatefulWidget {
  const Foodtruckgestionprofilfoodtruck({super.key});

  @override
  State<Foodtruckgestionprofilfoodtruck> createState() =>
      _FoodtruckgestionprofilfoodtruckState();
}

class _FoodtruckgestionprofilfoodtruckState
    extends State<Foodtruckgestionprofilfoodtruck> {
  File? _image;
  final picker = ImagePicker();

  // Méthode pour sélectionner une image depuis la galerie
  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });

      // Appeler la méthode d'upload après avoir sélectionné l'image
      if (_image != null) {
        String? imageUrl = await uploadImageToFirebase(_image!);
        if (imageUrl != null) {
          print("Image URL: $imageUrl");
        }
      }
    } else {
      print('No image selected.');
    }
  }

  // Méthode pour uploader l'image sur Firebase Storage
  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      // Obtenir le nom du fichier
      String fileName = path.basename(imageFile.path);

      // Créer une référence dans Firebase Storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profileImagesFoodTruck/$fileName');

      // Uploader le fichier
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // Attendre que l'upload soit complété
      TaskSnapshot taskSnapshot = await uploadTask;

      // Récupérer l'URL de téléchargement de l'image
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      print("Image uploaded to Firebase: $downloadURL");
      return downloadURL; // Retourner l'URL de l'image
    } catch (e) {
      print("Failed to upload image: $e");
      return null;
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
        actions: [],
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
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                title: const Text('Salut Food Truck Owner',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                subtitle: const Text('Votre espace gestion compte',
                    style: TextStyle(fontSize: 20)),
                trailing: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/images/foodtruck.jpg')
                              as ImageProvider,
                    ),
                    IconButton(
                        padding: EdgeInsets.all(50),
                        color: Colors.black,
                        onPressed: getImage,
                        icon: const Icon(Icons.add_a_photo)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Itemdashboard(
                        color: Colors.orange,
                        icon: Icons.app_settings_alt,
                        title: 'Creer un food truck',
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/pageFormFoodTruckProfil');
                        }),
                    Itemdashboard(
                        color: Colors.blue,
                        icon: Icons.location_on,
                        title: 'Modifier votre food truck',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.green,
                        icon: Icons.list,
                        title: 'Voir votre food truck',
                        onTap: () {}),
                    Itemdashboard(
                        color: Colors.red,
                        icon: Icons.close,
                        title: 'suprimer votre food truck',
                        onTap: () {}),
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
