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
          Sql.named('DROP TABLE pets;'),
        );
        await session.execute(
          Sql.named('DROP TABLE users;'),
        );
        await session.execute(
          Sql.named('DROP TABLE pet_types;'),
        );
      },
    );

    await db.close();
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  }
}
