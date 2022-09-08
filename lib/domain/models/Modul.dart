class Modul {
  final String id;
  final String name;
  final String informe;
  final String memorandum;
  final String solicitud;
  final String studentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Modul({
    required this.id,
    required this.name,
    required this.informe,
    required this.memorandum,
    required this.solicitud,
    required this.studentId,
    required this.createdAt,
    required this.updatedAt,
  });


    Modul copyWith({
    String? id,
    String? name,
    String? informe,
    String? memorandum,
    String? solicitud,
    String? studentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Modul(
      id: id ?? this.id,
      name: name ?? this.name,
      informe: informe ?? this.informe,
      memorandum: memorandum ?? this.memorandum,
      solicitud: solicitud ?? this.solicitud,
      studentId: studentId ?? this.studentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


  factory Modul.fromJson(Map<String, dynamic> json) => Modul(
        id: json['id'],
        name: json['name'],
        informe: json['informe'].toString(),
        memorandum: json['memorandum'],
        solicitud: json['solicitud'],
        studentId: json['student_id'],
        createdAt: DateTime.parse(json['created_at'].toDate().toString()),
        updatedAt: DateTime.parse(json['updated_at'].toDate().toString()),
      );

  Map<String, Object> toJson() => {
        "name": name,
        "informe": informe,
        "memorandum": memorandum,
        "solicitud": solicitud,
      };

  bool get isCompleted => informe != '' && memorandum != '' && solicitud != '';
}
