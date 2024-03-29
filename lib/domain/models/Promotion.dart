class Promotion {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Promotion({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  Promotion copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json['id'],
        name: json['name'],
        createdAt: DateTime.parse(json['created_at'].toDate().toString()),
        updatedAt: DateTime.parse(json['updated_at'].toDate().toString()),
      );

  Map<String, Object> toJson() => {
        "name": name,
      };
}
