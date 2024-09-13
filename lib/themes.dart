import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE5E5E5),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF212121),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
    iconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );
}
