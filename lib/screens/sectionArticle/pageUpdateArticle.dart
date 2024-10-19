import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:rolling_foods_app_front_end/models/article.dart';
import 'package:rolling_foods_app_front_end/services/article_service.dart';
import 'package:path/path.dart' as path;

class UpdatePageArticle extends StatefulWidget {
  final int articleId;
  const UpdatePageArticle({super.key, required this.articleId});

  @override
  State<UpdatePageArticle> createState() => _UpdatePageArticleState();
}

class _UpdatePageArticleState extends State<UpdatePageArticle> {
  late Future<Article> article;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _selectedCategoryController =
      TextEditingController();
  String _selectedCategory = '';
  File? _image;
  final picker = ImagePicker();
  String? imageUrl;

  final List<MultiSelectItem<String>> _categories = [
    MultiSelectItem("PROMOTION", "Promotion"),
    MultiSelectItem("SPECIALITY", "Spécialité"),
    MultiSelectItem("NEW", "Nouveauté"),
  ];

  @override
  void initState() {
    super.initState();
    article = ArticleService().fetchArticleById(widget.articleId);
    article.then((value) {
      _nameController.text = value.name;
      _descriptionController.text = value.description;
      _priceController.text = value.price.toString();
      _selectedCategoryController.text = value.itemCategorie;
    });
  }

  // Method to upload an image
  // Method to upload an image
  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Call the upload method after selecting the image
      if (_image != null) {
        imageUrl = await uploadImageToFirebase(_image!);
        if (imageUrl != null) {
          print("Image URL: $imageUrl");
        }
      }
    } else {
      print('No image selected.');
    }
  }

  // Méthode pour uploader l'image sur Firebase Storage
  // Méthode pour uploader l'image sur Firebase Storage
  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      // Obtenir le nom du fichier
      String fileName = path.basename(imageFile.path);

      // Créer une référence dans Firebase Storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profileImagesFoods/$fileName + ${DateTime.now()}');

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Call the createFoodTruck method
      await ArticleService().updateArticleById(
        id: widget.articleId,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        itemCategorie: _selectedCategory,
        pictureItem: imageUrl ?? '',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article updated successfully!'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Article'),
      ),
      body: FutureBuilder<Article>(
        future: article,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: getImage,
                        child: _image != null
                            ? Image.file(_image!)
                            : snapshot.data!.urlPicture != ''
                                ? Image.network(snapshot.data!.urlPicture ?? '')
                                : const Icon(Icons.add_a_photo),
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une description';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'Prix'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un prix';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _selectedCategoryController,
                        decoration:
                            const InputDecoration(labelText: 'Catégorie'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une catégorie';
                          }
                          return null;
                        },
                      ),
                      MultiSelectDialogField(
                        items: _categories,
                        title: const Text("Catégories"),
                        selectedColor: Colors.blue,
                        buttonIcon: const Icon(Icons.arrow_drop_down),
                        buttonText: const Text("Sélectionner une catégorie"),
                        onConfirm: (results) {
                          _selectedCategory = results.join(',');
                          _selectedCategoryController.text = _selectedCategory;
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select one or more options'
                            : null,
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Mettre à jour l\'article'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load article: ${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
