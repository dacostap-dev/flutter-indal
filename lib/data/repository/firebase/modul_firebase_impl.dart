import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/domain/models/Modul.dart';
import 'package:indal/domain/repository/modul_repository.dart';
import 'package:indal/providers/dependencies_provider.dart';

enum ModulQuery {
  name,
  createdAt,
}

final filterModulProvider = StateProvider((ref) => ModulQuery.name);

extension on Query<Modul> {
  /// Create a firebase query from a [ModulQuery]
  Query<Modul> queryBy(ModulQuery query) {
    switch (query) {
      case ModulQuery.name:
        return orderBy('name', descending: true);

      case ModulQuery.createdAt:
        return orderBy('created_at', descending: true);
    }
  }
}

class ModulFiresbaseImplementation extends ModulRepository {
  final Ref ref;
  late CollectionReference<Modul> modulRef;

  ModulFiresbaseImplementation(this.ref) {
    modulRef =
        ref.read(firebaseProvider).collection('moduls').withConverter<Modul>(
              fromFirestore: (snapshot, _) => Modul.fromJson(snapshot.data()!),
              toFirestore: (modul, _) => modul.toJson(),
            );
  }

  @override
  Future<List<Modul>> getModulsByStudent(String studentId) async {
    final orderBy = ref.read(filterModulProvider);

    print(studentId);

    return await modulRef
        .where('student_id', isEqualTo: studentId)
        .orderBy('created_at', descending: true)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    }).catchError((e) {
      throw Exception(e);
    });
  }

  @override
  Future<Modul> addModul({
    required String name,
    required String informe,
    required String memorandum,
    required String solicitud,
    required String studentId,
  }) async {
    final newDoc = ref.read(firebaseProvider).collection('moduls').doc();

    return await newDoc.set({
      'id': newDoc.id,
      'name': name,
      'informe': informe,
      'memorandum': memorandum,
      'solicitud': solicitud,
      'student_id': studentId,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }).then((res) async {
      return Modul(
        id: newDoc.id,
        name: name,
        informe: informe,
        memorandum: memorandum,
        solicitud: solicitud,
        studentId: studentId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Future<void> deleteModul({required String modulId}) async {
    await modulRef.doc(modulId).delete();
  }

  @override
  Future<void> updateModul({
    required String modulId,
    required String name,
    required String informe,
    required String memorandum,
    required String solicitud,
  }) async {
    return await modulRef.doc(modulId).update({
      'name': name,
      "informe": informe,
      "memorandum": memorandum,
      "solicitud": solicitud,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
