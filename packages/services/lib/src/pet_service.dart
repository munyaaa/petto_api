import 'package:data/data.dart';
import 'package:repositories/repositories.dart';

abstract class PetService {
  Future<List<PetTypeResponse>> getPetTypes();
  Future<int> createPet({
    required int userId,
    required CreateUpdatePetRequest request,
  });
}

class PetServiceImpl implements PetService {
  PetServiceImpl({required this.petRepository});

  final PetRepository petRepository;

  @override
  Future<List<PetTypeResponse>> getPetTypes() async {
    final petTypes = await petRepository.getPetTypes();

    return petTypes
        .map(
          (e) => PetTypeResponse(
            id: e.id,
            type: e.type,
            imageUrl: e.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<int> createPet({
    required int userId,
    required CreateUpdatePetRequest request,
  }) async {
    final typeId = request.typeId;
    final name = request.name;
    final age = request.age;
    final weight = request.weight;

    if (typeId == null || name == null || age == null || weight == null) {
      throw Exception('Incomplete Data');
    }

    final petId = await petRepository.postPet(
      userId: userId,
      typeId: typeId,
      name: name,
      age: age,
      weight: weight,
    );

    if (petId == null) {
      throw Exception('Failed to save pet');
    }

    return petId;
  }
}
