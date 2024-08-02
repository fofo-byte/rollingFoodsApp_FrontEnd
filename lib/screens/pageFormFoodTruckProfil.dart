import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PageFormFoodTruckProfil extends StatefulWidget {
  @override
  _PageFormFoodTruckProfilState createState() =>
      _PageFormFoodTruckProfilState();
}

class _PageFormFoodTruckProfilState extends State<PageFormFoodTruckProfil> {
  // Define your variables and controllers here
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Truck Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Add your form fields and widgets here
              // For example, you can use TextFormField for text input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Food Truck Name',
                ),
                // Add your logic to handle the input value
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Food Truck Name',
                ),
                // Add your logic to handle the input value
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description du Food Truck',
                ),
                // Add your logic to handle the input value
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Type de foods',
                ),
                // Add your logic to handle the input value
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              if (_image != null)
                Image.file(
                  _image!,
                  height: 200,
                ),

              ElevatedButton(
                onPressed: () {
                  // Add your logic to save the form data
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
