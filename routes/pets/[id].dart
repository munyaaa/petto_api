import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:data/data.dart';
import 'package:postgres/postgres.dart';
import 'package:services/services.dart';

FutureOr<Response> onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, id),
    HttpMethod.put => _onPut(context, id),
    HttpMethod.delete => _onDelete(context, id),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onGet(RequestContext context, String id) async {
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

    final petId = int.tryParse(id);

    if (petId == null) {
      throw Exception('Invalid pet id');
    }

    final pet = await petService.getPetById(
      petId,
      userId: userId,
    );

    return Response.json(
      body: {
        'data': pet.toJson(),
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

Future<Response> _onPut(RequestContext context, String id) async {
  final petService = context.read<PetService>();
  final db = await context.read<Future<Connection>>();

  try {
    final body = await context.request.json() as Map<String, dynamic>?;

    final petId = int.tryParse(id);

    if (petId == null) {
      throw Exception('Invalid pet id');
    }

    return Response.json(
      body: {
        'data': {
          'id': await petService.updatePet(
            petId,
            request: UpdatePetRequest.fromJson(
              body ?? {},
            ),
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

Future<Response> _onDelete(RequestContext context, String id) async {
  final petService = context.read<PetService>();
  final db = await context.read<Future<Connection>>();

  try {
    final petId = int.tryParse(id);

    if (petId == null) {
      throw Exception('Invalid pet id');
    }

    return Response.json(
      body: {
        'data': {
          'id': await petService.deletePet(petId),
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
