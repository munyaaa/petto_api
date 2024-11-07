import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

abstract class TokenService {
  int? verifyToken(String token);
  int? getUserIdByToken(String token);
  String? generateToken(int id);
}

class TokenServiceImpl implements TokenService {
  @override
  int? verifyToken(String token) {
    try {
      final tokenSecret = Platform.environment['TOKEN_SECRET'];

      if (tokenSecret == null) {
        return null;
      }

      final payload = JWT.verify(
        token,
        SecretKey(tokenSecret),
      );

      final data = payload.payload as Map<String, dynamic>;

      return int.tryParse(data['sub'] as String? ?? '');
    } catch (e) {
      return null;
    }
  }

  @override
  int? getUserIdByToken(String token) {
    final data = JWT.tryDecode(token)?.payload as Map<String, dynamic>;
    return int.tryParse(data['sub'] as String? ?? '');
  }

  String? generateToken(int id) {
    final jwt = JWT({
      'sub': id.toString(),
    });

    final tokenSecret = Platform.environment['TOKEN_SECRET'];

    if (tokenSecret == null) {
      return null;
    }

    return jwt.sign(
      SecretKey(tokenSecret),
    );
  }
}
