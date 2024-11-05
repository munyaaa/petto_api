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
