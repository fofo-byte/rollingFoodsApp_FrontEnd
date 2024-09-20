import 'package:flutter/material.dart';

final ThemeData rollingFoodsTheme = ThemeData(
  // Définir les couleurs principales
  primaryColor: Colors.black, // Couleur principale (noir)
  scaffoldBackgroundColor: Colors.white,

  // Définir la police de l'application (optionnelle)
  fontFamily: 'Roboto', // Utiliser une police de Google Fonts

  // Définir le style des AppBars
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black, // Icônes de la barre d'application en noir
    ),
    elevation: 0, // Sans ombre
  ),

  // Définir le style des boutons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green, // Boutons verts
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Texte blanc sur bouton
      ),
    ),
  ),

  // Style des textes
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleLarge: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.grey[800],
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.grey[600],
    ),
  ),

  // Style des Input (Champs de texte)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200,
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      color: Colors.grey.shade500,
    ),
  ),

  // Style des BottomNavigationBar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.green, // Icônes actives en vert
    unselectedItemColor: Colors.grey, // Icônes inactives en gris
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(
        primary: Colors.black,
        secondary: Colors.green, // Couleur secondaire (vert UberEats)
      )
      .copyWith(background: Colors.white),
);
