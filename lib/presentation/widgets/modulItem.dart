import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Modul.dart';
import 'package:indal/presentation/pages/moduls/modul_detail.dart';

import 'package:skeleton_text/skeleton_text.dart';

class ModulItem extends ConsumerWidget {
  final Modul modul;

  const ModulItem({
    Key? key,
    required this.modul,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModulDetail(modul: modul),
            )),
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: modul.isCompleted ? Colors.blue.shade400 : Colors.red.shade400,
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
            ),
          ],
        ),
        child: Center(child: Text(modul.name)),
      ),
    );
    return Dismissible(
      key: ValueKey(modul.id),
      onDismissed: (direction) => print(modul.id),
      child: ListTile(
        title: Text(modul.name),
        leading: const Icon(
          Icons.account_circle,
          size: 32,
        ),
      ),
    );
  }
}

class ModulSkeleton extends StatelessWidget {
  const ModulSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      shimmerColor: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
      shimmerDuration: 1000,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
