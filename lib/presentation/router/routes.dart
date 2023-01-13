import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:indal/domain/models/Promotion.dart';
import 'package:indal/domain/models/Student.dart';
import 'package:indal/presentation/notifiers/auth/auth_notifier.dart';
import 'package:indal/presentation/notifiers/promotion/promotion_notifier.dart';
import 'package:indal/presentation/notifiers/student/student_notifier.dart';

import 'package:indal/presentation/pages/home.dart';
import 'package:indal/presentation/pages/login.dart';

import 'package:indal/presentation/pages/promotions/promotion_detail.dart';
import 'package:indal/presentation/pages/splash.dart';
import 'package:indal/presentation/pages/students/student_detail.dart';
import 'package:indal/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStream = ref.read(authCubit.notifier).stream;

  return GoRouter(
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      authStream.where((state) => state is AuthSuccess || state is AuthLogout),
    ),
    redirect: (state) {
      print('redirect');

      final currentState = ref.read(authCubit);
      final isLogging = state.location == state.namedLocation('login');

      if (currentState is AuthSuccess && isLogging) {
        return state.namedLocation('home');
      }

      if (currentState is AuthLogout && !isLogging) {
        return state.namedLocation('login');
      }

      return null;
    },
    navigatorBuilder: (_, __, child) => SafeArea(child: child),
    routes: <GoRoute>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: [
          GoRoute(
            path: 'promotions/:promotionId',
            name: 'promotion-detail',
            builder: (BuildContext context, GoRouterState state) {
              print('test-builder-promotion');

              final promotionId = state.params['promotionId'];

              print('promotionId: $promotionId');

              //TODO: SI SE REFRESCA EL NAVEGADOR PIERDO EL STATE Y NO ENCUENTRA LA PROMOCION

              /*       final promotion = ref
                  .read(promotionListProvider)
                  .where((promotion) => promotion.id == promotionId)
                  .first;              
              */

              final promotions = ref.read(promotionCubit);
              final promotion = promotions.whenData((items) {
                return items
                    .where((promotion) => promotion.id == promotionId)
                    .first;
              });

              return PromotionDetail(promotion: promotion.value!);
            },
            routes: [
              GoRoute(
                path: 'student/:studentId',
                name: 'student-promotion-detail',
                builder: (BuildContext context, GoRouterState state) {
                  print('test-builder-student');

                  //print('subloc ${state.subloc}');

                  final studentId = state.params['studentId'];

                  print('studentId: $studentId');

                  //TODO: SI SE REFRESCA EL NAVEGADOR PIERDO EL STATE Y NO ENCUENTRA EL STUDENT

                  final studentsByPromotion = ref.read(studentCubit);

                  final student = studentsByPromotion.whenData((items) {
                    return items
                        .where((student) => student.id == studentId)
                        .first;
                  });

                  // print(studentsByPromotion);

                  return StudentDetail(student: student.value!);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'student/:studentId',
            name: 'student-detail',
            builder: (BuildContext context, GoRouterState state) {
              print('test-builder-student');

              final studentId = state.params['studentId'];

              print('studentId: $studentId');

              //TODO: SI SE REFRESCA EL NAVEGADOR PIERDO EL STATE Y NO ENCUENTRA EL STUDENT

              final studentsByPromotion = ref.read(studentCubit);

              final student = studentsByPromotion.whenData((items) {
                return items.where((student) => student.id == studentId).first;
              });

              return StudentDetail(student: student.value!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/',
        redirect: (state) => state.namedLocation('home'),
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
    ],
  );
});

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
        settings: const RouteSettings(name: 'student-detail'),
        builder: ((context) => StudentDetail(student: student)),
      );

    default:
      throw Exception('Not found route');
  }
}
