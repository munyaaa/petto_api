import 'dart:io';

import 'package:migrant/migrant.dart';
import 'package:migrant/testing.dart';
import 'package:migrant_db_postgresql/migrant_db_postgresql.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  final migrations = InMemory([
    Migration('0002', [
      '''
          INSERT INTO pet_types (type, image_url)
          VALUES 
            ('Cat', 'https://asset-2.tstatic.net/wartakota/foto/bank/images/bobby-kertanegara.jpg'),
            ('Dog', 'https://images.ctfassets.net/sfnkq8lmu5d7/1wwJDuKWXF4niMBJE9gaSH/97b11bcd7d41039f3a8eb5c3350acdfd/2024-05-24_Doge_meme_death_-_Hero.jpg'),
            ('Chick', 'https://media.wired.com/photos/5926ea697034dc5f91bed0a4/4:3/w_929,h_697,c_limit/GettyImages-79312712-fa.jpg'),
            ('Hamster', 'https://www.healthy-pet.com/cdn/shop/articles/home-yourpets-hamster_1200x630.jpg'),
            ('Fish', 'https://gpriority.co.id/wp-content/uploads/2023/01/images-45-1.jpeg'),
            ('Bird', 'https://i.ebayimg.com/images/g/s6cAAOSwl2BeTtN9/s-l1200.jpg');
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
