import 'package:dart_frog/dart_frog.dart';
import 'package:petto_api/middlewares/bearer_authentication_middleware.dart';
import 'package:petto_api/middlewares/db_middleware.dart';
import 'package:postgres/postgres.dart';
import 'package:repositories/repositories.dart';
import 'package:services/services.dart';

Handler middleware(Handler handler) {
  return handler
      .use(
        bearerAuthenticationMiddleware(),
      )
      .use(
        provider<TokenService>(
          (context) => TokenServiceImpl(),
        ),
      )
      .use(
        provider<PetService>(
          (context) => PetServiceImpl(
            petRepository: context.read<PetRepository>(),
          ),
        ),
      )
      .use(
        provider<PetRepository>(
          (context) => PetRepositoryImpl(
            db: context.read<Future<Connection>>(),
          ),
        ),
      )
      .use(
        dbProvider(),
      )
      .use(
        requestLogger(),
      );
}
