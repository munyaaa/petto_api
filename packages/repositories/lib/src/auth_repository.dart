import 'package:postgres/postgres.dart';

abstract class AuthRepository {
  Future<int?> createUser({
    required String email,
    required String hashedPassword,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.db,
  });

  final Future<Connection> db;

  @override
  Future<int?> createUser({
    required String email,
    required String hashedPassword,
  }) async {
    final result = (await (await db).execute(
      Sql.named('''
            INSERT INTO users (email, hashed_password)
            VALUES (@email, @hashed_password)
            RETURNING id;
          '''),
      parameters: {
        'email': email,
        'hashed_password': hashedPassword,
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
