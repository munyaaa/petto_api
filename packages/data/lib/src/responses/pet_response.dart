class PetResponse {
  PetResponse({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image_url': imageUrl,
    };
  }

  final int id;
  final String name;
  final String type;
  final String imageUrl;
}
