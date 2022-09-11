import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:indal/presentation/notifiers/student/student_notifier.dart';

import 'package:indal/presentation/widgets/studentItem.dart';

import '../../../domain/models/Promotion.dart';

class PromotionDetail extends ConsumerStatefulWidget {
  final Promotion promotion;

  const PromotionDetail({
    Key? key,
    required this.promotion,
  }) : super(key: key);

  @override
  PromotionDetailState createState() => PromotionDetailState();
}

class PromotionDetailState extends ConsumerState<PromotionDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studentCubit.notifier).clearStudents();
      ref
          .read(studentCubit.notifier)
          .getStudentsByPromotion(widget.promotion.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StudentState>(studentCubit, (previous, next) {
      if (next is StudentUpdateSuccess) {
        ref.read(studentCubit.notifier).clearStudents();
        ref
            .read(studentCubit.notifier)
            .getStudentsByPromotion(widget.promotion.id);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.promotion.name),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(studentCubit);

          if (state is StudentByPromotionLoadFailed) {
            return const Center(child: Text('Error'));
          }

          if (state is StudentByPromotionLoaded) {
            if (state.students.isEmpty) {
              return const Center(child: Text('No hay alumnos'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: state.students.length,
              itemBuilder: (context, index) => StudentItem(
                student: state.students[index],
                onTap: () {
                  context.goNamed('student-promotion-detail', params: {
                    'promotionId': widget.promotion.id,
                    'studentId': state.students[index].id,
                  });
                },
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(10),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: 12,
            itemBuilder: (context, index) => const StudentSkeleton(),
          );
        },
      ),
    );
  }
}
