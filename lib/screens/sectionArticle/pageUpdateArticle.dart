import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        if (imageUrl != null) {
          print("Image URL: $imageUrl");
        }
      }
    } else {
      print('No image selected.');
    }
  }

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
      File? imageFile = _image; // On garde le fichier image directement

      // Appeler la méthode de mise à jour de l'article avec le fichier image
      await ArticleService().updateArticleById(
        id: widget.articleId,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        itemCategorie: _selectedCategory,
        pictureFile: imageFile, // Passe le fichier image, pas le chemin
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
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage(
                                        'assets/icons/hello-foods-high-resolution-logo.png')
                                    as ImageProvider,
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(80),
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
