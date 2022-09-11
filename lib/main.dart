import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:indal/core/constants/app_themes.dart';
import 'package:indal/firebase_options.dart';

import 'package:indal/presentation/router/routes.dart';

final themeProvider = StateProvider(((ref) => false));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final isDark = ref.watch(themeProvider);
    final router = ref.read(routerProvider);

    print('build-general');

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // navigatorKey: _key,
      title: 'Flutter Demo',
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppThemes.darkTheme,
      theme: AppThemes.ligthTheme,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
