import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:data/data.dart';
import 'package:services/services.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final authService = context.read<AuthService>();

  try {
    final body = await context.request.json() as Map<String, dynamic>?;
    final request = RegisterRequest.fromJson(body ?? {});

    final userId = await authService.register(request);

    return Response.json(
      body: {
        'data': {
          'id': userId,
        },
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: e.toString(),
    );
  }
}
