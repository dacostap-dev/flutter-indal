import 'package:indal/domain/models/Promotion.dart';
import 'package:indal/domain/repository/promotion_repository.dart';

class PromotionLocalImpletation extends PromotionRepository {
  @override
  Future<Promotion> addPromotion({required String name}) {
    // TODO: implement addPromotion
    throw UnimplementedError();
  }

  @override
  Future<Promotion> deletePromotion({required String id}) {
    // TODO: implement deletePromotion
    throw UnimplementedError();
  }

  @override
  Future<List<Promotion>> getPromotions({Promotion? lastPromotion}) async {
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(
      10,
      (index) => Promotion(
        id: index.toString(),
        name: 'Promotion ${index + 1}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> updatePromotion({required Promotion promotion}) {
    // TODO: implement updatePromotion
    throw UnimplementedError();
  }
}
