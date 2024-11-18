import 'package:dart_frog/dart_frog.dart';
import 'package:petto_api/middlewares/bearer_authentication_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(
    bearerAuthenticationMiddleware(),
  );
}
