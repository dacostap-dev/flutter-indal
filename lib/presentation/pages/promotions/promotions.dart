import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Promotion.dart';

import 'package:indal/presentation/notifiers/promotion/promotion_notifier.dart';
import 'package:indal/presentation/widgets/promotionItem.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PromotionPage extends ConsumerStatefulWidget {
  const PromotionPage({Key? key}) : super(key: key);

  @override
  PromotionPageState createState() => PromotionPageState();
}

class PromotionPageState extends ConsumerState<PromotionPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    print('init');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  ref.read(promotionListProvider.notifier).state = [];
      ref.read(promotionCubit.notifier).getPromotions();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Promotion>>>(promotionCubit, (previous, next) {
      //null cuando esta en loading or error
      if (next.asData != null) {
        _refreshController.loadComplete();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promociones'),
        actions: <Widget>[
          PopupMenuButton<PromotionQuery>(
              onSelected: (value) async {
                ref.read(filterProvider.notifier).state = value;
                //  ref.read(promotionListProvider.notifier).state = [];

                ref.read(promotionCubit.notifier).getPromotions();
              },
              icon: const Icon(Icons.sort),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: PromotionQuery.name,
                    child: Text('Sort by Name'),
                  ),
                  const PopupMenuItem(
                    value: PromotionQuery.createdAt,
                    child: Text('Sort by CreatedAt'),
                  ),
                ];
              })
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final state = ref.watch(promotionCubit);

          return state.when(
            data: (data) {
              if (data.isEmpty) {
                return const Center(child: Text('No tiene promociones'));
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
                      body = const Text("Cargar más promociones");
                    } else {
                      body = const Text("No hay más promociones");
                    }
                    return SizedBox(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                // onRefresh: _onRefresh,
                onLoading: () {
                  ref.read(promotionCubit.notifier).getPromotions(
                        offset: data.length,
                        lastPromotion: data.last,
                      );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: data.length,
                  itemBuilder: (context, index) => PromotionItem(
                    promotion: data[index],
                  ),
                ),
              );
            },
            error: (err, st) => const Center(child: Text('Error')),
            loading: () => ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 10,
              itemBuilder: (context, index) => const PromotionSkeleton(),
            ),
          );
        },
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
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(hintText: 'Buscar'),
        onChanged: (String? text) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(
            const Duration(milliseconds: 300),
            (() async {
              print(_nameController.text);

              ref.read(searchProvider.notifier).state = _nameController.text;

              ref.read(promotionCubit.notifier).getPromotions();
            }),
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
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Crear Promoción'),
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
              hintText: 'Ingrese la promoción',
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
