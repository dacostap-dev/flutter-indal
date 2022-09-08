import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/data/repository/firebase/modul_firebase_impl.dart';
import 'package:indal/data/repository/firebase/promotion_firebase_impl.dart';
import 'package:indal/data/repository/firebase/students_firebase_impl.dart';
import 'package:indal/data/repository/local/auth_local_impl.dart';

import 'package:indal/domain/repository/auth_repository.dart';
import 'package:indal/domain/repository/modul_repository.dart';
import 'package:indal/domain/repository/promotion_repository.dart';
import 'package:indal/domain/repository/student_repository.dart';

final firebaseProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final authRepository = Provider<AuthRepository>((ref) {
  return AuthLocalImplementation();
});

final promotionRepository = Provider<PromotionRepository>((ref) {
  return PromotionFirebaseImplentation(ref);
});

final studentRepository = Provider<StudentRepository>((ref) {
  return StudentFirebaseImplentation(ref);
});

final modulRepository = Provider<ModulRepository>((ref) {
  return ModulFiresbaseImplementation(ref);
});
