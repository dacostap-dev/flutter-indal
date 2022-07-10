class Modul {
  final String id;
  final String name;
  final String informe;
  final String memorandum;

  final String solicitud;
  final String studentId;

  Modul({
    required this.id,
    required this.name,
    required this.informe,
    required this.memorandum,
    required this.solicitud,
    required this.studentId,
  });

  factory Modul.fromJson(Map<String, dynamic> json) => Modul(
        id: json['id'],
        name: json['name'],
        informe: json['informe'],
        memorandum: json['memorandum'],
        solicitud: json['solicitud'],
        studentId: json['studentId'],
      );

  bool get isCompleted => informe != '' && memorandum != '' && solicitud != '';
}
