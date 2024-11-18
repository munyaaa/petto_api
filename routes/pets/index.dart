import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:data/data.dart';
import 'package:postgres/postgres.dart';
import 'package:services/services.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final tokenService = context.read<TokenService>();
  final petService = context.read<PetService>();
  final db = await context.read<Future<Connection>>();

  try {
    final body = await context.request.json() as Map<String, dynamic>?;
    final token = context.request.headers['Authorization']
        ?.replaceFirst('Bearer', '')
        .trim();

    final userId = tokenService.getUserIdByToken(token ?? '');

    if (userId == null) {
      throw Exception('Invalid user id');
    }

    return Response.json(
      body: {
        'data': {
          'id': await petService.createPet(
            userId: userId,
            request: CreatePetRequest.fromJson(body ?? {}),
          ),
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

Future<Response> _onGet(RequestContext context) async {
  final tokenService = context.read<TokenService>();
  final petService = context.read<PetService>();
  final db = await context.read<Future<Connection>>();

  try {
    final token = context.request.headers['Authorization']
        ?.replaceFirst('Bearer', '')
        .trim();

    final userId = tokenService.getUserIdByToken(token ?? '');

    if (userId == null) {
      throw Exception('Invalid user id');
    }

    final pets = await petService.getAllPets(
      userId: userId,
    );

    return Response.json(
      body: {
        'data': {
          'pets': pets
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
