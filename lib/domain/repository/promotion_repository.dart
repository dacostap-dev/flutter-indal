import 'package:indal/domain/models/Promotion.dart';

abstract class PromotionRepository {
  Future<List<Promotion>> getPromotions({Promotion? lastPromotion});
  Future<Promotion> addPromotion({required String name});
  Future<void> updatePromotion({required Promotion promotion});
  Future<void> deletePromotion({required String id});
}
