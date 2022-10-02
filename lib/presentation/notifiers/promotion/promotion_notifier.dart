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

//final promotionListProvider = StateProvider<List<Promotion>>((ref) => []);

final promotionCubit =
    StateNotifierProvider<PromotionNotifier, AsyncValue<List<Promotion>>>(
        (ref) {
  //O pasar directamente el ref para que busque los repositorios que necesita

  return PromotionNotifier(ref.read(promotionRepository), ref);
});

class PromotionNotifier extends StateNotifier<AsyncValue<List<Promotion>>> {
  final PromotionRepository _promotionRepository;
  final Ref ref;

  PromotionNotifier(this._promotionRepository, this.ref)
      : super(const AsyncValue.loading());

/*   final List<Promotion> promotions = []; */

  void getPromotions({
    int offset = 0,
    Promotion? lastPromotion,
  }) {
    if (offset == 0) {
      //   state = PromotionLoading();
      state = const AsyncValue.loading();
    }

    _promotionRepository
        .getPromotions(lastPromotion: lastPromotion)
        .then((res) {
      print(res.length);

      if (lastPromotion != null) {
        state.whenData((items) => state = AsyncValue.data(items..addAll(res)));
      } else {
        state = AsyncValue.data(res);
      }
    }).catchError((e) {
      state = AsyncValue.error(e);
    });
  }

  void addPromotion(String name) {
    print('addPromotion');

    _promotionRepository.addPromotion(name: name).then(
      (value) {
        //   state = PromotionAddSuccess();

        state.whenData(
            (items) => state = AsyncValue.data(items..insertAll(0, [value])));
      },
    ).catchError((e) {
      print(e);
      state = AsyncValue.error(e);
    });
  }

  void updatePromotion(Promotion promotion) {
    print('updatePromotion');

    _promotionRepository.updatePromotion(promotion: promotion).then((value) {
      state.whenData((items) {
        state = AsyncValue.data([
          for (final item in items)
            if (item.id == promotion.id) promotion else item
        ]);
      });
    }).catchError((e) {
      print(e);
      state = AsyncValue.error(e);
    });
  }

  void deletePromotion(Promotion promotion) {
    print('deletePromotion');

    _promotionRepository.deletePromotion(id: promotion.id).then(
      (value) {
        // state = PromotionDeleteSuccess();
        state.whenData((items) => state = AsyncValue.data(
            items..removeWhere((item) => item.id == promotion.id)));
      },
    ).catchError((e) {
      print(e);
      state = AsyncValue.error(e);
    });
  }

}
