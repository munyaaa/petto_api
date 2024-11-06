class CreatePetRequest {
  CreatePetRequest({
    required this.typeId,
    required this.name,
    required this.age,
    required this.weight,
  });

  factory CreatePetRequest.fromJson(Map<String, dynamic> json) {
    return CreatePetRequest(
      typeId: json['type_id'] as int?,
      name: json['name'] as String?,
      age: json['age'] as int?,
      weight: json['weight'] as num?,
    );
  }

  final int? typeId;
  final String? name;
  final int? age;
  final num? weight;
}
