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
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                constraints: const BoxConstraints(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => UpdatePromotionDialog(promotion: promotion),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Eliminar Promoción'),
                      titleTextStyle: Theme.of(context).textTheme.titleMedium,
                      content: Text(
                        '¿Estás seguro que quieres eliminar la promoción ${promotion.name}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => {
                            ref
                                .read(promotionCubit.notifier)
                                .deletePromotion(promotion),
                            Navigator.pop(context)
                          },
                          child: const Text('Aceptar'),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
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

class UpdatePromotionDialog extends ConsumerStatefulWidget {
  final Promotion promotion;

  const UpdatePromotionDialog({
    Key? key,
    required this.promotion,
  }) : super(key: key);

  @override
  UpdatePromotionDialogState createState() => UpdatePromotionDialogState();
}

class UpdatePromotionDialogState extends ConsumerState<UpdatePromotionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late Promotion promotionEdited;

  @override
  void initState() {
    // TODO: implement initState

    _nameController.text = widget.promotion.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Editar Promoción'),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      contentPadding: const EdgeInsets.all(20),
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            validator: (text) {
              if (text == '') {
                return 'Ingrese el nombre de la promocion';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              promotionEdited = widget.promotion.copyWith(
                name: _nameController.text,
              );

              ref
                  .read(promotionCubit.notifier)
                  .updatePromotion(promotionEdited);

              Navigator.pop(context);
            }
          },
          child: const Text('Guardar'),
        )
      ],
    );
  }
}
