import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Promotion.dart';

import 'package:indal/domain/repository/promotion_repository.dart';
import 'package:indal/providers/dependencies_provider.dart';

part 'promotion_state.dart';

enum PromotionQuery {
  name,
  createdAt,
}

final filterProvider = StateProvider((ref) => PromotionQuery.name);

final promotionListProvider = StateProvider<List<Promotion>>((ref) => []);

final promotionCubit =
    StateNotifierProvider<PromotionNotifier, PromotionState>((ref) {
  //O pasar directamente el ref para que busque los repositorios que necesita

  return PromotionNotifier(ref.read(promotionRepository), ref);
});

class PromotionNotifier extends StateNotifier<PromotionState> {
  final PromotionRepository _promotionRepository;
  final Ref ref;

  PromotionNotifier(this._promotionRepository, this.ref)
      : super(PromotionInitial());

/*   final List<Promotion> promotions = []; */

  void getPromotions({
    int offset = 0,
    Promotion? lastPromotion,
  }) {
    if (offset == 0) {
      state = PromotionLoading();
    }

    _promotionRepository
        .getPromotions(lastPromotion: lastPromotion)
        .then((res) {
      ref.read(promotionListProvider).addAll(res);
      state = PromotionLoaded(ref.read(promotionListProvider));
    }).catchError((e) {
      print(e);
      state = PromotionLoadFailed(message: e.toString());
    });
  }

  void addPromotion(String name) {
    print('addPromotion');

    _promotionRepository.addPromotion(name: name).then(
      (value) {
        //   state = PromotionAddSuccess();
        ref.read(promotionListProvider).insertAll(0, [value]);
        state = PromotionLoaded(ref.read(promotionListProvider));
      },
    ).catchError((e) {
      print(e);
      state = PromotionAddFailed(message: e.toString());
    });
  }

  void deletePromotion(Promotion promotion) {
    print('deletePromotion');

    _promotionRepository.deletePromotion(id: promotion.id).then(
      (value) {
        // state = PromotionDeleteSuccess();
        ref
            .read(promotionListProvider)
            .removeWhere((element) => element.id == promotion.id);
        state = PromotionLoaded(ref.read(promotionListProvider));
      },
    ).catchError((e) {
      print(e);
      state = PromotionDeleteFailed(message: e.toString());
    });
  }

  void updatePromotion(Promotion promotion) {
    print('updatePromotion');

    _promotionRepository
        .updatePromotion(promotion: promotion)
        .then((value) => state = PromotionUpdatedSuccess())
        .catchError((e) {
      print(e);
      state = PromotionUpdateFailed(message: e.toString());
    });
  }

  void getStudentsByPromotion(String id) {
    state = PromotionLoading();

    _promotionRepository
        .getPromotions()
        .then((res) => state = PromotionLoaded(res))
        .catchError((e) {
      state = PromotionLoadFailed(message: e.toString());
    });
  }
}
