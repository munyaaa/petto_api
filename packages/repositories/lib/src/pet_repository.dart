import 'package:data/data.dart';
import 'package:postgres/postgres.dart';

abstract class PetRepository {
  Future<List<PetTypeEntity>> getPetTypes();
}

class PetRepositoryImpl implements PetRepository {
  PetRepositoryImpl({required this.db});

  final Future<Connection> db;

  @override
  Future<List<PetTypeEntity>> getPetTypes() async {
    final result = await (await db).execute(
      Sql.named('''
                SELECT id, type, image_url, created_at, updated_at
                FROM pet_types;
              '''),
      parameters: {},
    ).onError(
      (error, stackTrace) => Future.error(
        error.toString(),
      ),
    );

    return result
        .map(
          (e) => PetTypeEntity.fromMap(
            e.toColumnMap(),
          ),
        )
        .toList();
  }
}
