import 'package:dart_frog/dart_frog.dart';
import 'package:petto_api/middlewares/db_middleware.dart';
import 'package:postgres/postgres.dart';
import 'package:repositories/repositories.dart';
import 'package:services/services.dart';

Handler middleware(Handler handler) {
  return handler
      .use(
        provider<AuthService>(
          (context) => AuthServiceImpl(
            authRepository: context.read<AuthRepository>(),
            tokenService: context.read<TokenService>(),
          ),
        ),
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
        provider<AuthRepository>(
          (context) => AuthRepositoryImpl(
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
