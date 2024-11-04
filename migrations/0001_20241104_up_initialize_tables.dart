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
            image_url TEXT          
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
      host: 'localhost',
      database: 'postgres',
      username: 'postgres',
      password: 'postgres',
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );

  // The gateway is provided by this package.
  final gateway = PostgreSQLGateway(connection);

  // Applying migrations.
  await Database(gateway).upgrade(migrations);

  // At this point the table "foo" is ready. We're done.
  await connection.close();
}
