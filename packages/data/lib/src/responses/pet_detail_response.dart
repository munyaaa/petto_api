class PetDetailResponse {
  PetDetailResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.weight,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'age': age,
      'weight': weight,
      'image_url': imageUrl,
    };
  }

  final int id;
  final String name;
  final String type;
  final int age;
  final num weight;
  final String imageUrl;
}
