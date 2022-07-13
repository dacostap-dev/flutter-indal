import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/core/constants/app_themes.dart';
import 'package:indal/firebase_options.dart';
import 'package:indal/presentation/notifiers/auth/auth_notifier.dart';
import 'package:indal/presentation/router/routes.dart';
import 'package:indal/providers/auth_provider.dart';

final themeProvider = StateProvider(((ref) => false));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

final _key = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final isDark = ref.watch(themeProvider);

    ref.listen<AuthState>(authCubit, (previous, next) {
      if (next is AuthSuccess) {
        _key.currentState!
            .pushNamedAndRemoveUntil('home', ModalRoute.withName('home'));
      }

      if (next is AuthLogout) {
        _key.currentState!
            .pushNamedAndRemoveUntil('login', ModalRoute.withName('home'));
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _key,
      title: 'Flutter Demo',
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppThemes.darkTheme,
      theme: AppThemes.ligthTheme,
      initialRoute: 'splash',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
