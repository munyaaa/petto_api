import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:data/data.dart';
import 'package:postgres/postgres.dart';
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
  final db = await context.read<Future<Connection>>();

  try {
    final body = await context.request.json() as Map<String, dynamic>?;
    final request = LoginRequest.fromJson(body ?? {});

    final token = await authService.login(request);

    return Response.json(
      body: {
        'data': {
          'token': token,
        },
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: e.toString(),
    );
  } finally {
    if (db.isOpen) {
      await db.close();
    }
  }
}
