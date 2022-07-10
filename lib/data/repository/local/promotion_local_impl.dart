import 'package:indal/domain/models/Promotion.dart';
import 'package:indal/domain/repository/promotion_repository.dart';

class PromotionLocalImpletation extends PromotionRepository {
  @override
  Future<Promotion> addPromotion() {
    // TODO: implement addPromotion
    throw UnimplementedError();
  }

  @override
  Future<Promotion> deletePromotion() {
    // TODO: implement deletePromotion
    throw UnimplementedError();
  }

  @override
  Future<List<Promotion>> getPromotions() async {
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(
      10,
      (index) => Promotion(
        id: index.toString(),
        name: 'Promotion ${index+1}',
        userId: index.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<Promotion> updatePromotion() {
    // TODO: implement updatePromotion
    throw UnimplementedError();
  }
}
