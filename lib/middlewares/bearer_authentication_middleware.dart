import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:services/services.dart';

Middleware bearerAuthenticationMiddleware() {
  return (handler) {
    return handler.use(
      bearerAuthentication<int>(
        authenticator: (context, token) async {
          try {
            final tokenService = context.read<TokenService>();
            final userId = tokenService.verifyToken(token);

            if (userId == null) {
              return null;
            }

            final authService = context.read<AuthService>();
            final isUserExists = await authService.isUserExists(userId);

            if (!isUserExists) {
              return null;
            }

            return userId;
          } catch (e) {
            return null;
          }
        },
      ),
    );
  };
}
