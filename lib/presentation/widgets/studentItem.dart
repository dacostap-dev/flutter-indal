import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Student.dart';
import 'package:skeleton_text/skeleton_text.dart';

class StudentItem extends ConsumerWidget {
  final Student student;

  const StudentItem({
    Key? key,
    required this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(student.id),
      onDismissed: (direction) => print(student.id),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          'student-detail',
          arguments: student,
        ),
        title: Text(student.name),
        subtitle: Text(student.email),
        leading: const Icon(
          Icons.account_circle,
          size: 32,
        ),
      ),
    );
  }
}

class StudentSkeleton extends StatelessWidget {
  const StudentSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SkeletonAnimation(
          shimmerColor: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          shimmerDuration: 1000,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonAnimation(
                  shimmerColor: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  shimmerDuration: 1000,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SkeletonAnimation(
                  shimmerColor: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(50),
                  shimmerDuration: 1000,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
