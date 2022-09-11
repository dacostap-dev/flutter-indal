import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/providers/auth_provider.dart';

class ProfileUser extends ConsumerWidget {
  const ProfileUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alumnos'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => {
            ref.read(authCubit.notifier).logout(),
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
