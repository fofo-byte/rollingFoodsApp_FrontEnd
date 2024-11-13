import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:path/path.dart' as path;
import 'package:rolling_foods_app_front_end/models/foodTruck.dart';
import 'package:rolling_foods_app_front_end/services/foodTruck_service_API.dart';

class Updatepagefoodtruckprofil extends StatefulWidget {
  final int foodtruckId;
  const Updatepagefoodtruckprofil({super.key, required this.foodtruckId});

  @override
  State<Updatepagefoodtruckprofil> createState() =>
      _UpdatepagefoodtruckprofilState();
}

class _UpdatepagefoodtruckprofilState extends State<Updatepagefoodtruckprofil> {
  late Future<Foodtruck> foodtruck;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _foodTruckId = TextEditingController();
  List<String> _selectedFoodTypes = [];
  File? _image;
  final ImagePicker picker = ImagePicker();
  String? imageUrl;

  final List<MultiSelectItem<String>> _foodTypes = [
    MultiSelectItem("BURGER", "Burger"),
    MultiSelectItem("PIZZA", "Pizza"),
    MultiSelectItem("FRIES", "Frites"),
    MultiSelectItem("CHICKEN", "Chicken"),
    MultiSelectItem("HOTDOG", "Hotdog"),
    MultiSelectItem("CHINESE", "Chinese"),
    MultiSelectItem("SUSHI", "Sushi"),
    MultiSelectItem("PITTA", "Pitta"),
    MultiSelectItem("DURUM", "Durum"),
    MultiSelectItem("GLACES", "Glaces"),
  ];

  @override
  void initState() {
    super.initState();
    foodtruck = ApiService().fetchFoodTruckById(widget.foodtruckId);
    foodtruck.then((value) {
      _foodTruckId.text = value.id.toString();
      _nameController.text = value.name;
      _descriptionController.text = value.description;
      _specialityController.text = value.speciality;
      _selectedFoodTypes = value.foodTypes.split(',');
    });
  }

  // Method to upload an image
  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to submit the form
  Future<void> _submitForm() async {
    // Vérifie si l'image est sélectionnée
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une image'),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        Foodtruck foodtruckValue = await foodtruck;
        int foodTruckId = foodtruckValue.id;

        await ApiService().updateFoodTruck(
          id: foodTruckId,
          name: _nameController.text,
          description: _descriptionController.text,
          speciality: _specialityController.text,
          foodTypes: _selectedFoodTypes,
          profileImage: imageUrl,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Food Truck update successfully!'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/foodTruckAdmin');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to updade Food Truck!'),
          ),
        );
      }
    }
  }

  //Uplaoder image en local
  Future<void> uploadImage(File image, int foodTruckId) async {
    Foodtruck foodtruckValue = await foodtruck;
    int foodTruckId = foodtruckValue.id;

    try {
      String uplaodUrl = 'http://10.0.2.2:8686/api/uploadImage';

      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          image.path,
          filename: path.basename(image.path),
        ),
        "foodTruckId": foodTruckId,
      });

      Dio dio = new Dio();
      Response response = await dio.post(uplaodUrl, data: data);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        imageUrl = response.data['profileImage'];
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Food Truck'),
      ),
      body: FutureBuilder<Foodtruck>(
        future: foodtruck,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }
          Foodtruck foodtruck = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text('Food Truck ID: ${snapshot.data!.id}'),
                  GestureDetector(
                    onTap: getImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage(
                                  'assets/icons/hello-foods-high-resolution-logo.png')
                              as ImageProvider,
                      child:
                          _image == null ? const Icon(Icons.add_a_photo) : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        if (_image != null) {
                          uploadImage(_image!, foodtruck.id);
                        }
                      },
                      child: const Text('Upload Image')),
                  TextFormField(
                    controller: _foodTruckId,
                    decoration:
                        const InputDecoration(labelText: 'Food Truck ID'),
                    enabled: false,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _specialityController,
                    decoration: const InputDecoration(labelText: 'Speciality'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a speciality';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MultiSelectDialogField(
                      items: _foodTypes,
                      title: const Text("Food Types"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                          _selectedFoodTypes = results.cast<String>();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Update Food Truck'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
