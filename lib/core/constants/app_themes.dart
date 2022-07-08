import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static final ligthTheme = ThemeData(
    primarySwatch: Colors.red,
  );

  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
  );
}
