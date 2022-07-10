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

  void getPromotions({String search = ''}) {
    state = PromotionLoading();

    _promotionRepository
        .getPromotions()
        .then((res) => state = PromotionLoaded(res))
        .catchError((e) {
      state = PromotionLoadFailed();
    });
  }

  void addPromotion(String name) {
    print('addPromotion');
    final currentState = state;

    if (currentState is PromotionLoaded) {
      state = PromotionLoaded([
        ...currentState.promotions,
        Promotion(
          id: '123213',
          name: name,
          userId: '123123',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ]);
    }
  }

  void deletePromotion(Promotion promotion) {
    print('deletePromotion');
    final currentState = state;

    if (currentState is PromotionLoaded) {
      state = PromotionLoaded(
        currentState.promotions
            .where((element) => element.id != promotion.id)
            .toList(),
      );
    }
  }

  void getStudentsByPromotion(String id) {
    state = PromotionLoading();

    _promotionRepository
        .getPromotions()
        .then((res) => state = PromotionLoaded(res))
        .catchError((e) {
      state = PromotionLoadFailed();
    });
  }
}
