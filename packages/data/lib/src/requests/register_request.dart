class RegisterRequest {
  RegisterRequest({
    required this.username,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'] as String?,
      password: json['password'] as String?,
    );
  }

  final String? username;
  final String? password;
}
