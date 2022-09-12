import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:indal/domain/models/Student.dart';

import 'package:indal/domain/repository/student_repository.dart';

import 'package:indal/presentation/notifiers/student/student_notifier.dart';
import 'package:indal/providers/dependencies_provider.dart';

extension on Query<Student> {
  /// Create a firebase query from a [StudentQuery]
  Query<Student> queryBy(StudentQuery query, Student? lastStudent) {
    switch (query) {
      case StudentQuery.name:
        if (lastStudent != null) {
          return orderBy('name', descending: true).startAfter([
            lastStudent.name,
          ]);
        }
        return orderBy('name', descending: true);

      case StudentQuery.createdAt:
        if (lastStudent != null) {
          return orderBy('created_at', descending: true).startAfter([
            lastStudent.createdAt,
          ]);
        }
        return orderBy('created_at', descending: true);
    }
  }
}

class StudentFirebaseImplentation extends StudentRepository {
  final Ref ref;
  late CollectionReference<Student> studentsRef;

  StudentFirebaseImplentation(this.ref) {
    studentsRef = ref
        .read(firebaseProvider)
        .collection('students')
        .withConverter<Student>(
          fromFirestore: (snapshot, _) => Student.fromJson(snapshot.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );
  }
  @override
  Future<void> deleteStudent({required String id}) async {
    await studentsRef.doc(id).delete();
  }

  @override
  Future<List<Student>> getStudents({String? promotionId, Student? lastStudent}) async {
    final orderBy = ref.read(filterStudentProvider);

    print(lastStudent);

    return await studentsRef
        .where('promotion_id', isEqualTo: promotionId)
        .queryBy(orderBy, lastStudent)
        .limit(8)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    }).catchError((e) => throw Exception(e));
  }

  @override
  Future<List<Student>> getStudentsByPromotion(String promotionId) async {
    print(promotionId);

    return await studentsRef
        .where('promotion_id', isEqualTo: promotionId)
        .orderBy('created_at', descending: true)
        .get()
        .then((snapshot) {
      print(snapshot.docs);
      return snapshot.docs.map((doc) => doc.data()).toList();
    }).catchError((e) => throw Exception(e));
  }

  @override
  Future<Student> addStudent({
    required String name,
    required String email,
    required String gender,
    required String promotionId,
  }) async {
    final newDoc = ref.read(firebaseProvider).collection('students').doc();

    return await newDoc.set({
      'id': newDoc.id,
      'name': name,
      'email': email,
      'gender': gender,
      'promotion_id': promotionId,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }).then((res) async {
      return Student(
        id: newDoc.id,
        name: name,
        email: email,
        gender: gender,
        promotionId: promotionId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Future<void> updateStudent({
    required Student student,
  }) async {
    return await studentsRef.doc(student.id).update({
      'name': student.name,
      "email": student.email,
      "gender": student.gender,
      "promotionId": student.promotionId,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
