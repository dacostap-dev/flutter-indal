import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Promotion.dart';
import 'package:indal/domain/repository/promotion_repository.dart';
import 'package:indal/presentation/notifiers/promotion/promotion_notifier.dart';
import 'package:indal/providers/dependencies_provider.dart';

extension on Query<Promotion> {
  /// Create a firebase query from a [PromotionQuery]
  Query<Promotion> queryBy(PromotionQuery query, Promotion? lastPromotion) {
    switch (query) {
      case PromotionQuery.name:
        if (lastPromotion != null) {
          return orderBy('name', descending: true).startAfter([
            lastPromotion.name,
          ]);
        }
        return orderBy('name', descending: true);

      case PromotionQuery.createdAt:
        if (lastPromotion != null) {
          return orderBy('created_at', descending: true).startAfter([
            lastPromotion.createdAt,
          ]);
        }
        return orderBy('created_at', descending: true);
    }
  }
}

class PromotionFirebaseImplentation extends PromotionRepository {
  final Ref ref;
  late CollectionReference<Promotion> promotionsRef;

  PromotionFirebaseImplentation(this.ref) {
    promotionsRef = ref
        .read(firebaseProvider)
        .collection('promotions')
        .withConverter<Promotion>(
          fromFirestore: (snapshot, _) => Promotion.fromJson(snapshot.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );
  }

  @override
  Future<List<Promotion>> getPromotions({Promotion? lastPromotion}) async {
    final orderBy = ref.read(filterProvider);

    print(lastPromotion);

    return await promotionsRef
        //   .where('name', isGreaterThanOrEqualTo: search)
        .queryBy(orderBy, lastPromotion)
        .limit(8)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    }).catchError((e) => throw Exception(e));
  }

  @override
  Future<Promotion> addPromotion({required String name}) async {
    final newDoc = ref.read(firebaseProvider).collection('promotions').doc();

    return await newDoc.set({
      'id': newDoc.id,
      'name': name,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }).then((res) async {
      return Promotion(
        id: newDoc.id,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Future<void> deletePromotion({required String id}) async {
    await promotionsRef.doc(id).delete();
  }

  @override
  Future<void> updatePromotion({required Promotion promotion}) async {
    return await promotionsRef.doc(promotion.id).update({
      'name': promotion.name,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
