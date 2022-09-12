import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:indal/domain/models/Student.dart';

import 'package:indal/presentation/notifiers/student/student_notifier.dart';

import 'package:indal/presentation/widgets/studentItem.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /*   ref.read(studentCubit.notifier).clearStudents();
      ref
          .read(studentCubit.notifier)
          .getStudentsByPromotion(widget.promotion.id); */

      ref
          .read(studentCubit.notifier)
          .getStudents(promotionId: widget.promotion.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Student>>>(studentCubit, (previous, next) {
      //null cuando esta en loading or error
      if (next.asData != null) {
        _refreshController.loadComplete();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.promotion.name),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(studentCubit);

          return state.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(child: Text('No tiene Alumnos'));
              }

              return SmartRefresher(
                enablePullUp: true,
                enablePullDown: false,
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;
                    if (mode == LoadStatus.loading) {
                      body = const CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = const Text("Algo salió mal");
                    } else if (mode == LoadStatus.canLoading) {
                      body = const Text("Cargar más alumnos");
                    } else {
                      body = const Text("No hay más alumnos");
                    }
                    return SizedBox(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onLoading: () {
                  ref.read(studentCubit.notifier).getStudents(
                        offset: data.length,
                        lastStudent: data.last,
                        promotionId: widget.promotion.id,
                      );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: data.length,
                  itemBuilder: (context, index) => StudentItem(
                    student: data[index],
                    onTap: () {
                      context.goNamed('student-promotion-detail', params: {
                        'promotionId': widget.promotion.id,
                        'studentId': data[index].id,
                      });
                    },
                  ),
                ),
              );
            },
            error: (err, st) => const Center(child: Text('Error')),
            loading: () => ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 12,
              itemBuilder: (context, index) => const StudentSkeleton(),
            ),
          );
          /*        if (state is StudentByPromotionLoadFailed) {
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
          ); */
        },
      ),
    );
  }
}
