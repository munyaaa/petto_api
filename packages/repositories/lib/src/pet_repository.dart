import 'package:data/data.dart';
import 'package:postgres/postgres.dart';

abstract class PetRepository {
  Future<List<PetTypeEntity>> getPetTypes();
  Future<int?> postPet({
    required int userId,
    required int typeId,
    required String name,
    required int age,
    required num weight,
  });
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

  @override
  Future<int?> postPet({
    required int userId,
    required int typeId,
    required String name,
    required int age,
    required num weight,
  }) async {
    final result = (await (await db).execute(
      Sql.named(
        '''
          INSERT INTO pets (user_id, type_id, name, age, weight)
          VALUES (@user_id, @type_id, @name, @age, @weight)
          RETURNING id;
        ''',
      ),
      parameters: {
        'user_id': userId,
        'type_id': typeId,
        'name': name,
        'age': age,
        'weight': weight,
      },
    ).onError(
      (error, stackTrace) => Future.error(
        error.toString(),
      ),
    ))
        .singleOrNull;

    return result?.toColumnMap()['id'] as int?;
  }
}
