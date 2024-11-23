import 'package:data/data.dart';
import 'package:repositories/repositories.dart';

abstract class PetService {
  Future<List<PetTypeResponse>> getPetTypes();
  Future<int> createPet({
    required int userId,
    required CreatePetRequest request,
  });
  Future<PetDetailResponse> getPetById(
    int id, {
    required int userId,
  });
  Future<List<PetResponse>> getAllPets({
    required int userId,
  });
  Future<int> updatePet(
    int id, {
    required UpdatePetRequest request,
  });
  Future<int> deletePet(int id);
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
    required CreatePetRequest request,
  }) async {
    final typeId = request.typeId;
    final name = request.name;
    final age = request.age;
    final weight = request.weight;

    if (typeId == null || name == null || age == null || weight == null) {
      throw Exception('Incomplete Data');
    }

    final petId = await petRepository.insertPet(
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

  @override
  Future<PetDetailResponse> getPetById(
    int id, {
    required int userId,
  }) async {
    final pet = await petRepository.getPet(
      id,
      userId: userId,
    );

    if (pet == null) {
      throw Exception('Pet not found');
    }

    return PetDetailResponse(
      id: pet.id,
      name: pet.name,
      type: pet.type,
      age: pet.age,
      weight: pet.weight,
      imageUrl: pet.imageUrl,
    );
  }

  @override
  Future<List<PetResponse>> getAllPets({
    required int userId,
  }) async {
    final pets = await petRepository.getAllPets(
      userId: userId,
    );

    return pets
        .map(
          (e) => PetResponse(
            id: e.id,
            name: e.name,
            type: e.type,
            imageUrl: e.imageUrl,
          ),
        )
        .toList();
  }

  @override
  Future<int> updatePet(
    int id, {
    required UpdatePetRequest request,
  }) async {
    final name = request.name;
    final age = request.age;
    final weight = request.weight;

    if (name == null || age == null || weight == null) {
      throw Exception('Incomplete Data');
    }

    final petId = await petRepository.updatePet(
      id,
      name: name,
      age: age,
      weight: weight,
    );

    if (petId == null) {
      throw Exception('Failed to save pet');
    }

    return petId;
  }

  @override
  Future<int> deletePet(int id) async {
    final petId = await petRepository.deletePet(id);

    if (petId == null) {
      throw Exception('Failed to save pet');
    }

    return petId;
  }
}
