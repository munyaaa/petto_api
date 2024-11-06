class PetTypeResponse {
  PetTypeResponse({
    required this.id,
    required this.type,
    required this.imageUrl,
  });

  final int id;
  final String type;
  final String imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'image_url': imageUrl,
    };
  }
}
