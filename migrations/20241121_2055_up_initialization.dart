import 'dart:io';

import 'package:postgres/postgres.dart';

Future<void> main() async {
  try {
    final db = await Connection.open(
      Endpoint(
        host: Platform.environment['DB_HOST'] ?? '',
        database: Platform.environment['DB_NAME'] ?? '',
        username: Platform.environment['DB_USERNAME'] ?? '',
        password: Platform.environment['DB_PASSWORD'] ?? '',
        port: int.tryParse(Platform.environment['DB_PORT'] ?? '') ?? 5432,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    await db.runTx(
      (session) async {
        await session.execute(
          Sql.named('''
            CREATE TABLE pet_types (
              id SERIAL PRIMARY KEY,
              type VARCHAR(255) NOT NULL UNIQUE, 
              image_url TEXT,
              created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
              updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()     
            );
          '''),
        );

        await session.execute(
          Sql.named('''
            CREATE TABLE users (
              id BIGSERIAL PRIMARY KEY,
              username VARCHAR(255) UNIQUE NOT NULL,
              hashed_password VARCHAR(255) NOT NULL,
              created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
              updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );
          '''),
        );

        await session.execute(
          Sql.named('''
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
          '''),
        );
      },
    );

    await db.close();
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  }
}
