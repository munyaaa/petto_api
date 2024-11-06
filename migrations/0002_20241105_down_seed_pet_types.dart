import 'dart:io';

import 'package:migrant/migrant.dart';
import 'package:migrant/testing.dart';
import 'package:migrant_db_postgresql/migrant_db_postgresql.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  final migrations = InMemory([
    Migration('0002', ['DELETE FROM pet_types;']),
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
