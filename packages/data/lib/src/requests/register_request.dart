class RegisterRequest {
  RegisterRequest({
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] as String?,
      password: json['password'] as String?,
    );
  }

  final String? email;
  final String? password;
}
