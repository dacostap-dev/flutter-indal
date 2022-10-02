import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:indal/main.dart';
import 'package:indal/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.read(authCubit.notifier).getAuthUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  !ref.read(themeProvider.notifier).state;
            },
            icon: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final value = ref.watch(themeProvider);
                return value
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode);
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: authUser.photo,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 55,
                  backgroundImage: imageProvider,
                ),
                progressIndicatorBuilder: (context, url, progress) => SizedBox(
                  height: 110,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      value: progress.progress,
                    ),
                  ),
                ),
                // placeholder: (context, url) => CircleAvatar(
                //   backgroundColor: Theme.of(context).primaryColor,
                //   radius: 150,
                // ),
                errorWidget: (context, url, error) => const SizedBox(
                  height: 110,
                  child: Center(
                    child: Icon(
                      Icons.error,
                      size: 35,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 2),
                child: Text(
                  authUser.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 12),
                child: Text(
                  authUser.email,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _ProfileItem(
                icon: Icons.settings_outlined,
                label: 'Configuración',
                onTap: () {},
              ),
              const SizedBox(height: 15),
              _ProfileItem(
                icon: Icons.logout_outlined,
                label: 'Cerrar Sesión',
                onTap: ref.read(authCubit.notifier).logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.13),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 25,
            ),
            const SizedBox(width: 15),
            Expanded(
                child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )),
            const Icon(
              Icons.navigate_next,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
