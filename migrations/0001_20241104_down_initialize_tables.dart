import 'package:migrant/migrant.dart';
import 'package:migrant/testing.dart';
import 'package:migrant_db_postgresql/migrant_db_postgresql.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  final migrations = InMemory([
    Migration('0001', [
      'DROP TABLE pet_types;',
      'DROP TABLE users;',
      'DROP TABLE pets;',
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
