import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

abstract class TokenService {
  int? verifyToken(String token);
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
}
