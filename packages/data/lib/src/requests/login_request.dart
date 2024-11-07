class LoginRequest {
  LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      username: json['username'] as String?,
      password: json['password'] as String?,
    );
  }

  final String? username;
  final String? password;
}
