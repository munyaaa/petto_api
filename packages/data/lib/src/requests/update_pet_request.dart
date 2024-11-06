class UpdatePetRequest {
  UpdatePetRequest({
    required this.name,
    required this.age,
    required this.weight,
  });

  factory UpdatePetRequest.fromJson(Map<String, dynamic> json) {
    return UpdatePetRequest(
      name: json['name'] as String?,
      age: json['age'] as int?,
      weight: json['weight'] as num?,
    );
  }

  final String? name;
  final int? age;
  final num? weight;
}
