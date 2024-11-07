class UserEntity {
  UserEntity({
    required this.id,
    required this.username,
    required this.hashedPassword,
  });

  factory UserEntity.fromMap(Map<String, dynamic> row) {
    return UserEntity(
      id: row['id'] as int,
      username: row['username'] as String,
      hashedPassword: row['hashed_password'] as String,
    );
  }

  final int id;
  final String username;
  final String hashedPassword;
}
