import 'package:flutter/material.dart';

class Favoritespage extends StatefulWidget {
  const Favoritespage({super.key});

  @override
  State<Favoritespage> createState() => _FavoritespageState();
}

class _FavoritespageState extends State<Favoritespage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: const Center(
        child: Text('Favorites Page'),
      ),
    );
  }
}
