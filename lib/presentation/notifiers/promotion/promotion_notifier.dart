import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Promotion.dart';

import 'package:indal/domain/repository/promotion_repository.dart';
import 'package:indal/providers/dependencies_provider.dart';

part 'promotion_state.dart';

final promotionCubit =
    StateNotifierProvider<PromotionNotifier, PromotionState>((ref) {
  //O pasar directamente el ref para que busque los repositorios que necesita

  return PromotionNotifier(ref.read(promotionRepository));
});

class PromotionNotifier extends StateNotifier<PromotionState> {
  final PromotionRepository _promotionRepository;

  PromotionNotifier(this._promotionRepository) : super(PromotionInitial());

  void getPromotions() {
    state = PromotionLoading();

    _promotionRepository
        .getPromotions()
        .then((res) => state = PromotionLoaded(res))
        .catchError((e) {
      print(e);
      state = PromotionLoadFailed(message: e.toString());
    });
  }

  void addPromotion(String name) {
    print('addPromotion');

    _promotionRepository
        .addPromotion(name: name)
        .then((value) => state = PromotionAddSuccess())
        .catchError((e) {
      print(e);
      state = PromotionAddFailed(message: e.toString());
    });
  }

  void deletePromotion(Promotion promotion) {
    print('deletePromotion');

    _promotionRepository
        .deletePromotion(id: promotion.id)
        .then((value) => state = PromotionDeleteSuccess())
        .catchError((e) {
      print(e);
      state = PromotionDeleteFailed(message: e.toString());
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
