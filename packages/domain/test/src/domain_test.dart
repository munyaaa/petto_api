// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:domain/domain.dart';

void main() {
  group('Domain', () {
    test('can be instantiated', () {
      expect(Domain(), isNotNull);
    });
  });
}
