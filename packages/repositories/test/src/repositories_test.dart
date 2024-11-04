// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:repositories/repositories.dart';

void main() {
  group('Repositories', () {
    test('can be instantiated', () {
      expect(Repositories(), isNotNull);
    });
  });
}
