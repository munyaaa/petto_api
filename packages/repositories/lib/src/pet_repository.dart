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
  Future<PetDetailEntity?> getPet(
    int id, {
    required int userId,
  });
  Future<List<PetEntity>> getAllPets({
    required int userId,
  });
  Future<int?> updatePet(
    int id, {
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
    final result = await (await db)
        .execute(
          Sql.named('''
                SELECT id, type, image_url, created_at, updated_at
                FROM pet_types;
              '''),
        )
        .onError(
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

  @override
  Future<PetDetailEntity?> getPet(
    int id, {
    required int userId,
  }) async {
    final result = (await (await db).execute(
      Sql.named('''
                SELECT p.id, p.name, p.age, p.weight, pt.type, pt.image_url
                FROM pets p
                JOIN pet_types pt ON pt.id = p.type_id
                WHERE p.id = @id AND p.user_id = @user_id;
              '''),
      parameters: {
        'id': id,
        'user_id': userId,
      },
    ).onError(
      (error, stackTrace) => Future.error(
        error.toString(),
      ),
    ))
        .firstOrNull;

    if (result == null) {
      return null;
    }

    return PetDetailEntity.fromMap(
      result.toColumnMap(),
    );
  }

  @override
  Future<List<PetEntity>> getAllPets({required int userId}) async {
    final result = await (await db).execute(
      Sql.named('''
                SELECT p.id, p.name, pt.type, pt.image_url
                FROM pets p
                JOIN pet_types pt ON pt.id = p.type_id
                WHERE p.user_id = @user_id;
              '''),
      parameters: {
        'user_id': userId,
      },
    ).onError(
      (error, stackTrace) => Future.error(
        error.toString(),
      ),
    );

    return result
        .map(
          (e) => PetEntity.fromMap(
            e.toColumnMap(),
          ),
        )
        .toList();
  }

  @override
  Future<int?> updatePet(
    int id, {
    required String name,
    required int age,
    required num weight,
  }) async {
    final result = (await (await db).execute(
      Sql.named('''
                UPDATE pets
                SET name = @name,
                    age = @age,
                    weight = @weight,
                    updated_at = NOW()
                WHERE id = @id
                RETURNING id;
              '''),
      parameters: {
        'id': id,
        'name': name,
        'age': age,
        'weight': weight,
      },
    ).onError(
      (error, stackTrace) => Future.error(
        error.toString(),
      ),
    ))
        .firstOrNull;

    if (result == null) {
      return null;
    }

    return result.toColumnMap()['id'] as int?;
  }
}
