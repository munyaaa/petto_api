import 'package:bcrypt/bcrypt.dart';
import 'package:domain/domain.dart';
import 'package:repositories/repositories.dart';

abstract class AuthService {
  Future<int> register(RegisterRequest request);
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
}
