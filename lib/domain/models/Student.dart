class Student {
  final String id;
  final String email;
  final String gender;
  final String name;
  final String promotionId;

  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.email,
    required this.gender,
    required this.name,
    required this.promotionId,
    required this.createdAt,
    required this.updatedAt,
  });

  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? gender,
    String? promotionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      promotionId: promotionId ?? this.promotionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'],
        email: json['email'],
        gender: json['gender'],
        name: json['name'],
        promotionId: json['promotion_id'],
        createdAt: DateTime.parse(json['created_at'].toDate().toString()),
        updatedAt: DateTime.parse(json['updated_at'].toDate().toString()),
      );

  Map<String, Object> toJson() => {
        "name": name,
        "email": email,
        "gender": gender,
        "promotion_id": promotionId,
      };
}
