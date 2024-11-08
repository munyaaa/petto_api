import 'package:bcrypt/bcrypt.dart';
import 'package:data/data.dart';
import 'package:repositories/repositories.dart';
import 'package:services/services.dart';

abstract class AuthService {
  Future<int> register(RegisterRequest request);
  Future<String> login(LoginRequest request);
  Future<bool> isUserExists(int id);
}

class AuthServiceImpl implements AuthService {
  AuthServiceImpl({
    required this.authRepository,
    required this.tokenService,
  });

  final AuthRepository authRepository;
  final TokenService tokenService;

  @override
  Future<int> register(RegisterRequest request) async {
    final username = request.username ?? '';
    if (username.isEmpty) {
      throw Exception('username cannot be empty!');
    }
    final password = request.password ?? '';
    if (password.isEmpty) {
      throw Exception('Password cannot be empty!');
    }

    final userId = await authRepository.createUser(
      username: username,
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
    final username = request.username ?? '';
    if (username.isEmpty) {
      throw Exception('Username cannot be empty!');
    }

    final password = request.password ?? '';
    if (password.isEmpty) {
      throw Exception('Password cannot be empty!');
    }

    final user = await authRepository.getUser(username: username);

    if (user == null) {
      throw Exception('User not found!');
    }

    if (!BCrypt.checkpw(request.password ?? '', user.hashedPassword)) {
      throw Exception('Wrong password!');
    }

    final token = tokenService.generateToken(user.id);
    if (token == null) {
      throw Exception('Failed to generate token!');
    }

    return token;
  }

  @override
  Future<bool> isUserExists(int id) async {
    final userId = await authRepository.findUserById(id);
    return userId != null;
  }
}
