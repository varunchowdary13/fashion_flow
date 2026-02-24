import 'package:fashion_flow/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('should return error for null email', () {
      expect(Validators.email(null), 'Email is required');
    });

    test('should return error for empty email', () {
      expect(Validators.email(''), 'Email is required');
    });

    test('should return error for invalid email', () {
      expect(Validators.email('invalid'), 'Please enter a valid email address');
      expect(
        Validators.email('invalid@'),
        'Please enter a valid email address',
      );
      expect(Validators.email('@domain'), 'Please enter a valid email address');
      expect(
        Validators.email('user@domain'),
        'Please enter a valid email address',
      );
    });

    test('should return null for valid email', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('test.user@domain.co'), isNull);
      expect(Validators.email('name@sub.domain.org'), isNull);
    });
  });

  group('Validators.password', () {
    test('should return error for null password', () {
      expect(Validators.password(null), 'Password is required');
    });

    test('should return error for empty password', () {
      expect(Validators.password(''), 'Password is required');
    });

    test('should return error for short password', () {
      expect(
        Validators.password('12345'),
        'Password must be at least 6 characters',
      );
    });

    test('should return null for valid password', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('password123'), isNull);
    });
  });

  group('Validators.strongPassword', () {
    test('should return error for null password', () {
      expect(Validators.strongPassword(null), 'Password is required');
    });

    test('should return error for short password', () {
      expect(
        Validators.strongPassword('Abc123'),
        'Password must be at least 8 characters',
      );
    });

    test('should return error for password without uppercase', () {
      expect(
        Validators.strongPassword('abcdefg1'),
        'Password must contain at least one uppercase letter',
      );
    });

    test('should return error for password without lowercase', () {
      expect(
        Validators.strongPassword('ABCDEFG1'),
        'Password must contain at least one lowercase letter',
      );
    });

    test('should return error for password without number', () {
      expect(
        Validators.strongPassword('Abcdefgh'),
        'Password must contain at least one number',
      );
    });

    test('should return null for valid strong password', () {
      expect(Validators.strongPassword('Password1'), isNull);
      expect(Validators.strongPassword('MySecure123'), isNull);
    });
  });

  group('Validators.match', () {
    test('should return error for mismatched values', () {
      expect(
        Validators.match('password1', 'password2', 'Passwords'),
        'Passwords do not match',
      );
    });

    test('should return null for matching values', () {
      expect(Validators.match('password', 'password'), isNull);
    });
  });

  group('Validators.required', () {
    test('should return error for null value', () {
      expect(Validators.required(null), 'This field is required');
    });

    test('should return error for empty value', () {
      expect(Validators.required(''), 'This field is required');
    });

    test('should return error for whitespace-only value', () {
      expect(Validators.required('   '), 'This field is required');
    });

    test('should return null for non-empty value', () {
      expect(Validators.required('value'), isNull);
    });
  });
}
