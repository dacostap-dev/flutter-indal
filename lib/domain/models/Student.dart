class Student {
  final String id;
  final String email;
  final String gender;
  final String name;
  final String promocionId;

  Student({
    required this.id,
    required this.email,
    required this.gender,
    required this.name,
    required this.promocionId,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        email: json['email'],
        gender: json['gender'],
        name: json['name'],
        promocionId: json['promocionId'],
      );
}
