part of 'promotion_notifier.dart';

@immutable
abstract class PromotionState {}

class PromotionInitial extends PromotionState {}

class PromotionLoading extends PromotionState {}

class PromotionLoaded extends PromotionState {
  final List<Promotion> promotions;

  PromotionLoaded(this.promotions);
}

class PromotionLoadFailed extends PromotionState {}
