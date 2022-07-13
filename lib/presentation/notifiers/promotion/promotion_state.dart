part of 'promotion_notifier.dart';

@immutable
abstract class PromotionState {}

class PromotionInitial extends PromotionState {}

class PromotionLoading extends PromotionState {}

class PromotionLoaded extends PromotionState {
  final List<Promotion> promotions;

  PromotionLoaded(this.promotions);
}

class PromotionLoadFailed extends PromotionState {
  final String message;

  PromotionLoadFailed({required this.message});
}

//ADD
class PromotionAddSuccess extends PromotionState {}

class PromotionAddFailed extends PromotionState {
    final String message;

  PromotionAddFailed({required this.message});
}

//DELETE
class PromotionDeleteSuccess extends PromotionState {}

class PromotionDeleteFailed extends PromotionState {
    final String message;

  PromotionDeleteFailed({required this.message});
}

