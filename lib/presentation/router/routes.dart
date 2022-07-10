import 'package:flutter/material.dart';
import 'package:indal/domain/models/Promotion.dart';
import 'package:indal/domain/models/Student.dart';

import 'package:indal/presentation/pages/home.dart';
import 'package:indal/presentation/pages/login.dart';
import 'package:indal/presentation/pages/promotions/promotion_detail.dart';
import 'package:indal/presentation/pages/splash.dart';
import 'package:indal/presentation/pages/students/student_detail.dart';

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

    case 'promotion-detail':
      final promotion = settings.arguments as Promotion;
      return MaterialPageRoute(
        settings: const RouteSettings(name: 'promotion-detail'),
        builder: ((context) => PromotionDetail(promotion: promotion)),
      );

    case 'student-detail':
      final student = settings.arguments as Student;
      return MaterialPageRoute(
        settings: const RouteSettings(name: 'promotion-detail'),
        builder: ((context) => StudentDetail(student: student)),
      );

    default:
      throw Exception('Not found route');
  }
}
