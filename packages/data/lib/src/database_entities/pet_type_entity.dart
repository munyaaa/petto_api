class PetTypeEntity {
  PetTypeEntity({
    required this.id,
    required this.type,
    required this.imageUrl,
  });

  factory PetTypeEntity.fromMap(Map<String, dynamic> row) {
    return PetTypeEntity(
      id: row['id'] as int,
      type: row['type'] as String,
      imageUrl: row['image_url'] as String,
    );
  }

  final int id;
  final String type;
  final String imageUrl;
}
