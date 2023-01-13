import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static final ligthTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.amber,
    primaryColor: const Color(0xffff3a5a),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    primaryColor: const Color(0xffff3a5a),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(),
    ),
  );
}
