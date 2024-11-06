class PetDetailEntity {
  PetDetailEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.weight,
    required this.imageUrl,
  });

  factory PetDetailEntity.fromMap(Map<String, dynamic> row) {
    return PetDetailEntity(
      id: row['id'] as int,
      name: row['name'] as String,
      type: row['type'] as String,
      age: row['age'] as int,
      weight: row['weight'] as num,
      imageUrl: row['image_url'] as String,
    );
  }

  final int id;
  final String name;
  final String type;
  final int age;
  final num weight;
  final String imageUrl;
}
