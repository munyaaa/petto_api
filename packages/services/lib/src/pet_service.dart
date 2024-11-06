import 'package:data/data.dart';
import 'package:repositories/repositories.dart';

abstract class PetService {
  Future<List<PetTypeResponse>> getPetTypes();
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
}
