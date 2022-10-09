import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/presentation/notifiers/auth/auth_notifier.dart';
import 'package:indal/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    ref.listen<AuthState>(authCubit, (previous, next) {
      //null cuando esta en loading or error
      if (next is AuthFailed) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 30),
            Text(
              'Iniciar Sesión',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 20.5),
            ),
            const SizedBox(height: 35),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Correo electrónico',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: 'Contraseña',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            /*      Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, 'forget-password'),
                child: Text(
                  'No recuedo mi contraseña',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              ),
            ), */

            Consumer(
              builder: (context, ref, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 38),
                ),
                onPressed: ref.watch(authCubit) is AuthLoading
                    ? null
                    : () {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) return;

                        ref.read(authCubit.notifier).loginWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                            );
                      },
                child: const Text('INICIAR'),
              ),
            ),
            const SizedBox(height: 45),
            /*        const Text(
              '¿No tienes cuenta?',
              //style: TextStyle(),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                'Afíliate ahora',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ), */
            const Spacer()
          ],
        ),
      ),
    );
  }
}
