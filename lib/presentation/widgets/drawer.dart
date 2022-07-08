import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/providers/auth_provider.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          const ListTile(
            title: Text('Opcion 1'),
          ),
          const Spacer(),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              ref.read(authCubit.notifier).logout();
            },
          )
        ],
      ),
    );
  }
}
