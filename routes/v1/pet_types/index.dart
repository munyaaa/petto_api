import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import 'package:services/services.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final petService = context.read<PetService>();
  final db = await context.read<Future<Connection>>();

  try {
    final petTypes = await petService.getPetTypes();

    return Response.json(
      body: {
        'data': {
          'pet_types': petTypes
              .map(
                (e) => e.toJson(),
              )
              .toList(),
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
