import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:indal/presentation/notifiers/promotion/promotion_notifier.dart';
import 'package:indal/presentation/widgets/promotionItem.dart';

class PromotionPage extends ConsumerStatefulWidget {
  const PromotionPage({Key? key}) : super(key: key);

  @override
  PromotionPageState createState() => PromotionPageState();
}

class PromotionPageState extends ConsumerState<PromotionPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(promotionCubit.notifier).getPromotions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promociones'),
      ),
      body: Column(
        children: [
          const SearchPromotion(),
          Expanded(
            child: Consumer(
              builder: (context, ref, widget) {
                final state = ref.watch(promotionCubit);

                if (state is PromotionLoadFailed) {
                  return const Center(child: Text('Error'));
                }

                if (state is PromotionLoading) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(10),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: 12,
                    itemBuilder: (context, index) => const PromotionSkeleton(),
                  );
                }

                if (state is PromotionLoaded) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(10),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: state.promotions.length,
                    itemBuilder: (context, index) => PromotionItem(
                      promotion: state.promotions[index],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CreatePromotion(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

final searchProvider = StateProvider(((ref) => ''));

class SearchPromotion extends ConsumerStatefulWidget {
  const SearchPromotion({
    Key? key,
  }) : super(key: key);

  @override
  SearchPromotionState createState() => SearchPromotionState();
}

class SearchPromotionState extends ConsumerState<SearchPromotion> {
  final _nameController = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _nameController,
        decoration: const InputDecoration(hintText: 'Buscar'),
        onChanged: (String? text) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(
            const Duration(milliseconds: 300),
            (() => print(_nameController.text)),
          );
        },
      ),
    );
  }
}

class CreatePromotion extends ConsumerStatefulWidget {
  const CreatePromotion({
    Key? key,
  }) : super(key: key);

  @override
  CreatePromotionState createState() => CreatePromotionState();
}

class CreatePromotionState extends ConsumerState<CreatePromotion> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
              ref
                  .read(promotionCubit.notifier)
                  .addPromotion(_nameController.text);

              Navigator.pop(context);
            }
          },
          child: const Text('Guardar'),
        )
      ],
    );
  }
}