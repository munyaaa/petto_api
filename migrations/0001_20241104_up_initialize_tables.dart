import 'dart:io';

import 'package:migrant/migrant.dart';
import 'package:migrant/testing.dart';
import 'package:migrant_db_postgresql/migrant_db_postgresql.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  final migrations = InMemory([
    Migration('0001', [
      '''
          CREATE TABLE pet_types (
            id SERIAL PRIMARY KEY,
            type VARCHAR(255) NOT NULL UNIQUE, 
            image_url TEXT,
            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
            updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()     
          );
      ''',
      '''
          CREATE TABLE users (
            id BIGSERIAL PRIMARY KEY,
            email VARCHAR(255) UNIQUE NOT NULL,
            hashed_password VARCHAR(255) NOT NULL,
            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
            updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
          );
      ''',
      '''
          CREATE TABLE pets (
            id BIGSERIAL PRIMARY KEY,
            user_id BIGINT,
            type_id INT,
            name VARCHAR(255) NOT NULL,
            age INT,
            weight FLOAT8,
            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
            updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
            CONSTRAINT pets_user_id_fkey
                FOREIGN KEY(user_id)
                REFERENCES users(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE,
            CONSTRAINT pets_type_id_fkey
                FOREIGN KEY(type_id)
                REFERENCES pet_types(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE
          );
      ''',
    ]),
  ]);

  final connection = await Connection.open(
    Endpoint(
      host: Platform.environment['DB_HOST'] ?? '',
      database: Platform.environment['DB_NAME'] ?? '',
      username: Platform.environment['DB_USERNAME'] ?? '',
      password: Platform.environment['DB_PASSWORD'] ?? '',
      port: int.tryParse(Platform.environment['DB_PORT'] ?? '') ?? 5432,
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );

  final gateway = PostgreSQLGateway(connection);

  await Database(gateway).upgrade(migrations);

  await connection.close();
}
