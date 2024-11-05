class UserEntity {
  UserEntity({
    required this.id,
    required this.email,
    required this.hashedPassword,
  });

  factory UserEntity.fromMap(Map<String, dynamic> row) {
    return UserEntity(
      id: row['id'] as int,
      email: row['email'] as String,
      hashedPassword: row['hashed_password'] as String,
    );
  }

  final int id;
  final String email;
  final String hashedPassword;
}
