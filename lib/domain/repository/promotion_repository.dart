import 'package:indal/domain/models/Promotion.dart';

abstract class PromotionRepository {
  Future<List<Promotion>> getPromotions({String? search});
  Future<Promotion> addPromotion({required String name});
  Future<void> updatePromotion({required String name});
  Future<void> deletePromotion({required String id});
}
