class PetEntity {
  PetEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
  });

  factory PetEntity.fromMap(Map<String, dynamic> row) {
    return PetEntity(
      id: row['id'] as int,
      name: row['name'] as String,
      type: row['type'] as String,
      imageUrl: row['image_url'] as String,
    );
  }

  final int id;
  final String name;
  final String type;
  final String imageUrl;
}
