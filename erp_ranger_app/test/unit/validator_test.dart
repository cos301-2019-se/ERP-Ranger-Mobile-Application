
import 'package:erp_ranger_app/services/validator.dart';
import 'package:test_api/test_api.dart';

void main() {

  group('Validator Unit Tests', () {
    group('Validator (Email)', () {
      test('email should be valid', () {
        expect(Validator.email("test@test.com"), true);
      });

      test('email should be invalid', () {
        expect(Validator.email("test"), false);
      });

      test('email should be invalid', () {
        expect(Validator.email("test@"), false);
      });

      test('email should be invalid', () {
        expect(Validator.email("test@test."), false);
      });
    });

    group('Validator (Password)', () {
      test('password should be valid', () {
        expect(Validator.password("Test1234"), true);
      });

      test('password should be invalid', () {
        expect(Validator.password("TestTest"), false);
      });

      test('password should be invalid', () {
        expect(Validator.password("12345678"), false);
      });
    });
  });

}