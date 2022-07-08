import 'package:flutter/material.dart';

import 'package:indal/presentation/pages/home.dart';
import 'package:indal/presentation/pages/login.dart';
import 'package:indal/presentation/pages/splash.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'splash':
      return MaterialPageRoute(
        settings: const RouteSettings(name: 'splash'),
        builder: ((context) => const SplashPage()),
      );

    case 'login':
      return MaterialPageRoute(
        settings: const RouteSettings(name: 'login'),
        builder: ((context) => const LoginPage()),
      );

    case 'home':
      return MaterialPageRoute(
        settings: const RouteSettings(name: 'home'),
        builder: ((context) => const HomePage()),
      );

    default:
      throw Exception('Not found route');
  }
}
