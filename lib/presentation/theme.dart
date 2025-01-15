import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.black87,
    secondary: Colors.black54,
    surface: Colors.grey,
    onBackground: Colors.black87,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
    titleLarge: TextStyle(color: Colors.black87),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF121212), // A soft black
    primary: Colors.white70,
    secondary: Colors.white54,
    surface: Color(0xFF1E1E1E), // Slightly lighter than background
    onBackground: Colors.white70,
    onPrimary: Color(0xFF121212),
    onSecondary: Color(0xFF121212),
    onSurface: Colors.white70,
  ),
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white70,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(color: Colors.white70),
  ),
);
