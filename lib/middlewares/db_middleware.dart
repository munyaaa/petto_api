import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Middleware dbProvider() {
  return (handler) {
    return handler.use(
      provider<Future<Connection>>(
        (context) => Connection.open(
          Endpoint(
            host: Platform.environment['DB_HOST'] ?? '',
            database: Platform.environment['DB_NAME'] ?? '',
            username: Platform.environment['DB_USERNAME'] ?? '',
            password: Platform.environment['DB_PASSWORD'] ?? '',
            port: int.tryParse(Platform.environment['DB_PORT'] ?? '') ?? 5432,
          ),
          settings: const ConnectionSettings(
            sslMode: SslMode.disable,
          ),
        ),
      ),
    );
  };
}
