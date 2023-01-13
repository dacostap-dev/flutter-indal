import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/presentation/notifiers/auth/auth_notifier.dart';
import 'package:indal/presentation/widgets/app_header.dart';
import 'package:indal/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _emailController.text = "dacostap1.upao@gmail.com";
    _passwordController.text = "12345678";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.black;

    ref.listen<AuthState>(authCubit, (previous, next) {
      //null cuando esta en loading or error
      if (next is AuthFailed) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const AppHeader(),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Material(
                  color: Colors.white,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: _emailController,
                    decoration: InputDecoration(
                      // isDense: true,
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: primaryColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Material(
                  color: Colors.white,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      // isDense: true,
                      hintText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: primaryColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer(builder: (context, ref, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      fixedSize: Size(screenSize.width / 1, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: ref.watch(authCubit) is AuthLoading
                        ? null
                        : () {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) return;

                            ref
                                .read(authCubit.notifier)
                                .loginWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                          },
                    child: const Text('Login'),
                  );
                }),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'FORGOT PASSWORD?',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No tienes cuenta?',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Regístrate',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
