import 'package:indal/domain/models/Promotion.dart';

abstract class PromotionRepository {
  Future<List<Promotion>> getPromotions();
  Future<Promotion> addPromotion();
  Future<Promotion> updatePromotion();
  Future<void> deletePromotion();
}