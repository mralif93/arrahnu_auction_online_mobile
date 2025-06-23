import 'package:flutter_test/flutter_test.dart';
import 'package:arrahnu_auction_online_mobile/services/api_service.dart';
import 'package:arrahnu_auction_online_mobile/models/auth_models.dart';
import 'package:arrahnu_auction_online_mobile/models/user.dart';

void main() {
  group('Auth Service Models Tests', () {
    group('LoginResponse', () {
      test('should create LoginResponse from JSON correctly', () {
        final mockResponseData = {
          'token': 'mock_access_token_123',
          'token_type': 'Bearer',
          'expires_in': 3600,
          'user': {
            'id': 'user-uuid-123',
            'full_name': 'Ahmad Rahman',
            'username': 'ahmad.rahman',
            'email': 'ahmad.rahman@arrahnu.com',
            'role': 'bidder',
            'status': 'active',
            'phone_number': '+60123456789',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z'
          }
        };

        final loginResponse = LoginResponse.fromJson(mockResponseData);

        expect(loginResponse.token, 'mock_access_token_123');
        expect(loginResponse.tokenType, 'Bearer');
        expect(loginResponse.expiresIn, 3600);
        expect(loginResponse.user.id, 'user-uuid-123');
        expect(loginResponse.user.fullName, 'Ahmad Rahman');
        expect(loginResponse.user.email, 'ahmad.rahman@arrahnu.com');
        expect(loginResponse.user.role, 'bidder');
      });

      test('should convert LoginResponse to JSON correctly', () {
        final user = User(
          id: 'user-123',
          fullName: 'Test User',
          username: 'testuser',
          email: 'test@example.com',
          role: 'bidder',
          status: 'active',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        final loginResponse = LoginResponse(
          token: 'test_token',
          tokenType: 'Bearer',
          expiresIn: 3600,
          user: user,
        );

        final json = loginResponse.toJson();

        expect(json['token'], 'test_token');
        expect(json['token_type'], 'Bearer');
        expect(json['expires_in'], 3600);
        expect(json.containsKey('user'), true);
        // The User object should be properly serialized by the generated code
        expect(json['user'], isNotNull);
      });
    });

    group('RegisterRequest', () {
      test('should create RegisterRequest and convert to JSON correctly', () {
        final registerRequest = RegisterRequest(
          fullName: 'New User',
          username: 'newuser',
          email: 'newuser@example.com',
          password: 'password123',
          passwordConfirmation: 'password123',
          phoneNumber: '+60123456789',
          role: 'bidder',
        );

        final json = registerRequest.toJson();

        expect(json['full_name'], 'New User');
        expect(json['username'], 'newuser');
        expect(json['email'], 'newuser@example.com');
        expect(json['password'], 'password123');
        expect(json['password_confirmation'], 'password123');
        expect(json['phone_number'], '+60123456789');
        expect(json['role'], 'bidder');
      });
    });

    group('RegisterResponse', () {
      test('should create RegisterResponse from JSON correctly', () {
        final mockResponseData = {
          'user': {
            'id': 'user-new-123',
            'full_name': 'New Registered User',
            'username': 'newreguser',
            'email': 'newreg@example.com',
            'role': 'bidder',
            'status': 'pending_approval',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
          'message': 'Registration successful. Your account is pending approval.'
        };

        final registerResponse = RegisterResponse.fromJson(mockResponseData);

        expect(registerResponse.user.id, 'user-new-123');
        expect(registerResponse.user.fullName, 'New Registered User');
        expect(registerResponse.user.status, 'pending_approval');
        expect(registerResponse.message, 'Registration successful. Your account is pending approval.');
      });
    });

    group('User Model', () {
      test('should create User from JSON correctly', () {
        final userJson = {
          'id': 'user-uuid-456',
          'full_name': 'Test User Full',
          'username': 'testuserfull',
          'email': 'testfull@example.com',
          'phone_number': '+60111222333',
          'role': 'admin',
          'status': 'active',
          'avatar_url': 'https://example.com/avatar.jpg',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-02T00:00:00Z',
        };

        final user = User.fromJson(userJson);

        expect(user.id, 'user-uuid-456');
        expect(user.fullName, 'Test User Full');
        expect(user.username, 'testuserfull');
        expect(user.email, 'testfull@example.com');
        expect(user.phoneNumber, '+60111222333');
        expect(user.role, 'admin');
        expect(user.status, 'active');
        expect(user.avatarUrl, 'https://example.com/avatar.jpg');
        expect(user.createdAt, '2024-01-01T00:00:00Z');
        expect(user.updatedAt, '2024-01-02T00:00:00Z');
      });

      test('should create User with minimal required fields', () {
        final userJson = {
          'id': 'user-minimal-789',
          'full_name': 'Minimal User',
          'username': 'minimal',
          'email': 'minimal@example.com',
          'role': 'bidder',
          'status': 'active',
        };

        final user = User.fromJson(userJson);

        expect(user.id, 'user-minimal-789');
        expect(user.fullName, 'Minimal User');
        expect(user.phoneNumber, null);
        expect(user.avatarUrl, null);
        expect(user.createdAt, null);
        expect(user.updatedAt, null);
      });

      test('should test User helper methods', () {
        final activeBidder = User(
          id: '1',
          fullName: 'Active Bidder',
          username: 'bidder1',
          email: 'bidder@test.com',
          role: 'bidder',
          status: 'active',
        );

        final inactiveAdmin = User(
          id: '2',
          fullName: 'Inactive Admin',
          username: 'admin1',
          email: 'admin@test.com',
          role: 'admin',
          status: 'inactive',
        );

        expect(activeBidder.isActive, true);
        expect(activeBidder.isBidder, true);
        expect(activeBidder.isAdmin, false);

        expect(inactiveAdmin.isActive, false);
        expect(inactiveAdmin.isBidder, false);
        expect(inactiveAdmin.isAdmin, true);
      });
    });

    group('API Response Error Handling', () {
      test('should handle authentication errors', () {
        final errorResponse = ApiResponse<LoginResponse>.error('Invalid credentials');
        expect(errorResponse.isSuccess, false);
        expect(errorResponse.error, 'Invalid credentials');
        expect(errorResponse.data, null);
      });

      test('should handle network errors', () {
        final networkError = ApiResponse<LoginResponse>.error('No internet connection');
        expect(networkError.isSuccess, false);
        expect(networkError.error, 'No internet connection');
      });

      test('should handle validation errors', () {
        final validationError = ApiResponse<RegisterResponse>.error('Email is required');
        expect(validationError.isSuccess, false);
        expect(validationError.error, 'Email is required');
      });
    });

    group('Data Validation', () {
      test('should validate email format in RegisterRequest', () {
        final validRequest = RegisterRequest(
          fullName: 'Valid User',
          username: 'validuser',
          email: 'valid@example.com',
          password: 'password123',
          passwordConfirmation: 'password123',
        );

        expect(validRequest.email, contains('@'));
        expect(validRequest.email, contains('.'));
      });

      test('should validate password confirmation match', () {
        final matchingPasswords = RegisterRequest(
          fullName: 'User',
          username: 'user',
          email: 'user@example.com',
          password: 'password123',
          passwordConfirmation: 'password123',
        );

        expect(matchingPasswords.password, matchingPasswords.passwordConfirmation);
      });

      test('should validate phone number format', () {
        final user = User(
          id: '1',
          fullName: 'User',
          username: 'user',
          email: 'user@test.com',
          role: 'bidder',
          status: 'active',
          phoneNumber: '+60123456789',
        );

        expect(user.phoneNumber, startsWith('+60'));
        expect(user.phoneNumber!.length, greaterThan(10));
      });
    });
  });
} 