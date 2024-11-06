import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:data/data.dart';
import 'package:repositories/repositories.dart';

abstract class AuthService {
  Future<int> register(RegisterRequest request);
  Future<String> login(LoginRequest request);
}

class AuthServiceImpl implements AuthService {
  AuthServiceImpl({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<int> register(RegisterRequest request) async {
    final email = request.email ?? '';
    if (email.isEmpty) {
      throw Exception('Email cannot be empty!');
    }
    final password = request.password ?? '';
    if (password.isEmpty) {
      throw Exception('Password cannot be empty!');
    }

    final userId = await authRepository.createUser(
      email: email,
      hashedPassword: BCrypt.hashpw(
        password,
        BCrypt.gensalt(),
      ),
    );

    if (userId == null) {
      throw Exception('Invalid user');
    }

    return userId;
  }

  @override
  Future<String> login(LoginRequest request) async {
    final email = request.email ?? '';
    if (email.isEmpty) {
      throw Exception('Email cannot be empty!');
    }

    final password = request.password ?? '';
    if (password.isEmpty) {
      throw Exception('Password cannot be empty!');
    }

    final user = await authRepository.getUser(email: email);

    if (user == null) {
      throw Exception('User not found!');
    }

    if (!BCrypt.checkpw(request.password ?? '', user.hashedPassword)) {
      throw Exception('Wrong password!');
    }

    final token = _generateToken(user.id);
    if (token == null) {
      throw Exception('Failed to generate token!');
    }

    return token;
  }

  String? _generateToken(int id) {
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
