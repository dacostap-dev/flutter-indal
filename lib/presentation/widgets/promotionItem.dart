import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Promotion.dart';
import 'package:indal/presentation/notifiers/promotion/promotion_notifier.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';

class PromotionItem extends ConsumerWidget {
  final Promotion promotion;

  const PromotionItem({
    Key? key,
    required this.promotion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Dismissible(
      key: ValueKey(promotion.id),
      onDismissed: (direction) =>
          ref.read(promotionCubit.notifier).deletePromotion(promotion),
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          'promotion-detail',
          arguments: promotion,
        ),
        title: Text(promotion.name),
        subtitle: Text(dateFormat.format(promotion.createdAt)),
        leading: const Icon(Icons.school),
      ),
    );
  }
}

class PromotionSkeleton extends StatelessWidget {
  const PromotionSkeleton({
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
