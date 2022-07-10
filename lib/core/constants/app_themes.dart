import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static final ligthTheme = ThemeData(
    primarySwatch: Colors.red,
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
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(),
    ),
  );
}
