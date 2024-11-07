import 'package:data/data.dart';
import 'package:postgres/postgres.dart';

abstract class AuthRepository {
  Future<int?> createUser({
    required String username,
    required String hashedPassword,
  });
  Future<UserEntity?> getUser({
    required String username,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.db,
  });

  final Future<Connection> db;

  @override
  Future<int?> createUser({
    required String username,
    required String hashedPassword,
  }) async {
    final result = (await (await db).execute(
      Sql.named('''
            INSERT INTO users (username, hashed_password)
            VALUES (@username, @hashed_password)
            RETURNING id;
          '''),
      parameters: {
        'username': username,
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

  @override
  Future<UserEntity?> getUser({
    required String username,
  }) async {
    final result = (await (await db).execute(
      Sql.named('''
            SELECT id, username, hashed_password 
            FROM users 
            WHERE username=@username;
          '''),
      parameters: {
        'username': username,
      },
    ).onError(
      (error, stackTrace) => Future.error(
        error.toString(),
      ),
    ))
        .singleOrNull;

    if (result == null) {
      return null;
    }

    return UserEntity.fromMap(
      result.toColumnMap(),
    );
  }
}
