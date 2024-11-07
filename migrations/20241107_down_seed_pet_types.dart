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

    await db.execute(
      Sql.named('DELETE FROM pet_types;'),
    );

    await db.close();
  } catch (e) {
    stderr.writeln('Error: $e');
    exit(1);
  }
}
