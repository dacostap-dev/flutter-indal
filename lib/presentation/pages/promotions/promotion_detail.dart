import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      ref
          .read(studentCubit.notifier)
          .getStudentsByPromotion(widget.promotion.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.promotion.name),
      ),
      body: Consumer(
        builder: (context, ref, widget) {
          final state = ref.watch(studentCubit);

          if (state is StudentLoadFailed) {
            return const Center(child: Text('Error'));
          }

          if (state is StudentLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 12,
              itemBuilder: (context, index) => const StudentSkeleton(),
            );
          }

          if (state is StudentLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: state.students.length,
              itemBuilder: (context, index) => StudentItem(
                student: state.students[index],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}