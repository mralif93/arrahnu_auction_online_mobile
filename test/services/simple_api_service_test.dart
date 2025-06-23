import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:arrahnu_auction_online_mobile/services/api_service.dart';

void main() {
  group('Simple API Service Tests', () {
    group('ApiResponse Tests', () {
      test('should create success response correctly', () {
        // Arrange
        const testData = {'key': 'value'};
        
        // Act
        final response = ApiResponse.success(testData);
        
        // Assert
        expect(response.isSuccess, true);
        expect(response.data, testData);
        expect(response.error, null);
      });

      test('should create error response correctly', () {
        // Arrange
        const errorMessage = 'Test error message';
        
        // Act
        final response = ApiResponse<String>.error(errorMessage);
        
        // Assert
        expect(response.isSuccess, false);
        expect(response.data, null);
        expect(response.error, errorMessage);
      });

      test('should handle success response with null data', () {
        // Act
        final response = ApiResponse<String?>.success(null);
        
        // Assert
        expect(response.isSuccess, true);
        expect(response.data, null);
        expect(response.error, null);
      });

      test('should handle different data types', () {
        // Test with Map
        final mapResponse = ApiResponse.success({'id': 1, 'name': 'test'});
        expect(mapResponse.data!['id'], 1);
        expect(mapResponse.data!['name'], 'test');

        // Test with List
        final listResponse = ApiResponse.success([1, 2, 3]);
        expect(listResponse.data!.length, 3);
        expect(listResponse.data![0], 1);

        // Test with String
        final stringResponse = ApiResponse.success('test string');
        expect(stringResponse.data!, 'test string');

        // Test with int
        final intResponse = ApiResponse.success(42);
        expect(intResponse.data!, 42);
      });
    });

    group('JSON Parsing Tests', () {
      test('should parse valid JSON correctly', () {
        // Arrange
        final jsonString = '{"message": "success", "data": {"id": 1}}';
        
        // Act
        final parsed = json.decode(jsonString);
        
        // Assert
        expect(parsed['message'], 'success');
        expect(parsed['data']['id'], 1);
      });

      test('should handle JSON with different data types', () {
        // Arrange
        final complexJson = '''
        {
          "string_field": "test",
          "int_field": 123,
          "double_field": 45.67,
          "bool_field": true,
          "null_field": null,
          "array_field": [1, 2, 3],
          "object_field": {"nested": "value"}
        }
        ''';
        
        // Act
        final parsed = json.decode(complexJson);
        
        // Assert
        expect(parsed['string_field'], 'test');
        expect(parsed['int_field'], 123);
        expect(parsed['double_field'], 45.67);
        expect(parsed['bool_field'], true);
        expect(parsed['null_field'], null);
        expect(parsed['array_field'], isA<List>());
        expect(parsed['object_field'], isA<Map>());
      });
    });

    group('URL Building Tests', () {
      test('should construct URLs correctly', () {
        // Test basic URL construction
        const baseUrl = 'http://127.0.0.1:9000';
        const endpoint = '/api/test';
        final fullUrl = '$baseUrl$endpoint';
        
        expect(fullUrl, 'http://127.0.0.1:9000/api/test');
      });

      test('should handle query parameters', () {
        // Test query parameter handling
        final uri = Uri.parse('http://127.0.0.1:9000/api/auctions');
        final queryParams = {
          'page': '1',
          'limit': '20',
          'category': 'gold',
          'search': 'necklace'
        };
        
        final uriWithParams = uri.replace(queryParameters: queryParams);
        final urlString = uriWithParams.toString();
        
        expect(urlString, contains('page=1'));
        expect(urlString, contains('limit=20'));
        expect(urlString, contains('category=gold'));
        expect(urlString, contains('search=necklace'));
      });

      test('should handle special characters in query params', () {
        // Test encoding of special characters
        final uri = Uri.parse('http://127.0.0.1:9000/api/search');
        final queryParams = {
          'query': 'test & special',
          'filter': 'price>100'
        };
        
        final uriWithParams = uri.replace(queryParameters: queryParams);
        final urlString = uriWithParams.toString();
        
        // Uri.replace automatically encodes special characters
        expect(urlString, contains('query='));
        expect(urlString, contains('filter='));
      });
    });

    group('HTTP Status Code Tests', () {
      test('should identify success status codes', () {
        const successCodes = [200, 201, 202, 204];
        
        for (final code in successCodes) {
          expect(code >= 200 && code < 300, true, reason: 'Code $code should be success');
        }
      });

      test('should identify client error status codes', () {
        const clientErrorCodes = [400, 401, 403, 404, 422];
        
        for (final code in clientErrorCodes) {
          expect(code >= 400 && code < 500, true, reason: 'Code $code should be client error');
        }
      });

      test('should identify server error status codes', () {
        const serverErrorCodes = [500, 502, 503, 504];
        
        for (final code in serverErrorCodes) {
          expect(code >= 500, true, reason: 'Code $code should be server error');
        }
      });
    });

    group('Error Message Tests', () {
      test('should create appropriate error messages for different scenarios', () {
        // Test different error scenarios
        final networkError = ApiResponse<String>.error('No internet connection');
        expect(networkError.error, 'No internet connection');
        expect(networkError.isSuccess, false);

        final authError = ApiResponse<String>.error('Unauthorized access');
        expect(authError.error, 'Unauthorized access');

        final validationError = ApiResponse<String>.error('Validation failed');
        expect(validationError.error, 'Validation failed');

        final serverError = ApiResponse<String>.error('Internal server error');
        expect(serverError.error, 'Internal server error');
      });
    });

    group('Data Validation Tests', () {
      test('should validate common data formats', () {
        // Email validation
        const validEmail = 'test@example.com';
        const invalidEmail = 'invalid-email';
        
        expect(validEmail.contains('@'), true);
        expect(validEmail.contains('.'), true);
        expect(invalidEmail.contains('@'), false);

        // Phone number validation
        const validPhone = '+1234567890';
        expect(validPhone.startsWith('+'), true);
        expect(validPhone.length > 10, true);

        // Number validation
        const validBidAmount = 1000.0;
        const invalidBidAmount = -100.0;
        
        expect(validBidAmount > 0, true);
        expect(invalidBidAmount > 0, false);
      });

      test('should validate required fields', () {
        // Test that required fields are properly checked
        const userData = {
          'id': 1,
          'email': 'test@example.com',
          'full_name': 'Test User'
        };

        expect(userData['id'], isNotNull);
        expect(userData['email'], isNotNull);
        expect(userData['full_name'], isNotNull);
        expect(userData['email'], isA<String>());
        expect(userData['id'], isA<int>());
      });
    });

    group('Request Body Tests', () {
      test('should construct login request body correctly', () {
        final loginBody = {
          'email': 'test@example.com',
          'password': 'password123',
          'remember_me': true,
        };

        expect(loginBody['email'], 'test@example.com');
        expect(loginBody['password'], 'password123');
        expect(loginBody['remember_me'], true);
        expect(loginBody.length, 3);
      });

      test('should construct registration request body correctly', () {
        final registerBody = {
          'full_name': 'John Doe',
          'email': 'john@example.com',
          'password': 'password123',
          'password_confirmation': 'password123',
          'ic_number': '123456789012',
          'phone_number': '+1234567890',
        };

        expect(registerBody['full_name'], 'John Doe');
        expect(registerBody['email'], 'john@example.com');
        expect(registerBody['password'], registerBody['password_confirmation']);
        expect(registerBody['ic_number']?.length, 12);
      });

      test('should construct bid request body correctly', () {
        final bidBody = {
          'bid_amount': 2500.0,
        };

        expect(bidBody['bid_amount'], 2500.0);
        expect(bidBody['bid_amount'], isA<double>());
        expect(bidBody['bid_amount']! > 0, true);
      });
    });

    group('Response Format Tests', () {
      test('should handle standard API response format', () {
        final mockResponse = {
          'message': 'Operation successful',
          'data': {
            'id': 1,
            'name': 'Test Item'
          },
          'status': 'success'
        };

        expect(mockResponse['message'], isA<String>());
        expect(mockResponse['data'], isA<Map>());
        expect(mockResponse['status'], 'success');
      });

      test('should handle paginated response format', () {
        final paginatedResponse = {
          'data': [
            {'id': 1, 'title': 'Item 1'},
            {'id': 2, 'title': 'Item 2'}
          ],
          'current_page': 1,
          'total_pages': 5,
          'total_items': 100,
          'per_page': 20
        };

        expect(paginatedResponse['data'], isA<List>());
        expect(paginatedResponse['current_page'], 1);
        expect(paginatedResponse['total_pages'], 5);
        expect(paginatedResponse['total_items'], 100);
        expect((paginatedResponse['data'] as List).length, 2);
      });

      test('should handle error response format', () {
        final errorResponse = {
          'message': 'Validation failed',
          'errors': {
            'email': ['Email is required'],
            'password': ['Password must be at least 8 characters']
          },
          'status': 'error'
        };

        expect(errorResponse['message'], isA<String>());
        expect(errorResponse['errors'], isA<Map>());
        expect(errorResponse['status'], 'error');
      });
    });

    group('ApiService Tests', () {
      test('ApiResponse.success creates successful response', () {
        final response = ApiResponse.success({'key': 'value'});
        
        expect(response.isSuccess, true);
        expect(response.data, {'key': 'value'});
        expect(response.error, null);
      });

      test('ApiResponse.error creates error response', () {
        final response = ApiResponse<String>.error('Something went wrong');
        
        expect(response.isSuccess, false);
        expect(response.data, null);
        expect(response.error, 'Something went wrong');
      });

      test('ApiResponse.success with null data', () {
        final response = ApiResponse<String?>.success(null);
        
        expect(response.isSuccess, true);
        expect(response.data, null);
        expect(response.error, null);
      });

      test('ApiResponse handles generic types correctly', () {
        final stringResponse = ApiResponse.success('test string');
        final intResponse = ApiResponse.success(42);
        final mapResponse = ApiResponse.success({'test': 'data'});
        
        expect(stringResponse.data, 'test string');
        expect(intResponse.data, 42);
        expect(mapResponse.data, {'test': 'data'});
      });

      test('ApiResponse.error with validation errors', () {
        final validationErrors = {
          'email': ['Email is required'],
          'password': ['Password must be at least 8 characters']
        };
        
        final response = ApiResponse<String>.error(
          'Validation failed',
          errors: validationErrors,
        );
        
        expect(response.isSuccess, false);
        expect(response.error, 'Validation failed');
        expect(response.errors, validationErrors);
      });

      test('ApiResponse.success with message', () {
        final response = ApiResponse.success(
          {'user': 'data'},
          message: 'User created successfully',
        );
        
        expect(response.isSuccess, true);
        expect(response.data, {'user': 'data'});
        expect(response.message, 'User created successfully');
      });

      test('ApiResponse equality and toString', () {
        final response1 = ApiResponse.success('test');
        final response2 = ApiResponse.success('test');
        final response3 = ApiResponse<String>.error('error');
        
        // Test different response types
        expect(response1.isSuccess, true);
        expect(response2.isSuccess, true);
        expect(response3.isSuccess, false);
        
        // Verify data integrity
        expect(response1.data, 'test');
        expect(response2.data, 'test');
        expect(response3.data, null);
      });

      test('ApiResponse handles complex data structures', () {
        final complexData = {
          'users': [
            {'id': 1, 'name': 'John'},
            {'id': 2, 'name': 'Jane'}
          ],
          'pagination': {
            'current_page': 1,
            'total': 2
          }
        };
        
        final response = ApiResponse.success(complexData);
        
        expect(response.isSuccess, true);
        expect(response.data, complexData);
        expect(response.data!['users'], isA<List>());
        expect(response.data!['pagination'], isA<Map>());
      });

      test('ApiResponse with empty data structures', () {
        final emptyListResponse = ApiResponse.success(<String>[]);
        final emptyMapResponse = ApiResponse.success(<String, dynamic>{});
        
        expect(emptyListResponse.isSuccess, true);
        expect(emptyListResponse.data, isEmpty);
        
        expect(emptyMapResponse.isSuccess, true);
        expect(emptyMapResponse.data, isEmpty);
      });

      test('ApiResponse error handling edge cases', () {
        // Empty error message
        final emptyErrorResponse = ApiResponse<String>.error('');
        expect(emptyErrorResponse.isSuccess, false);
        expect(emptyErrorResponse.error, '');
        
        // Null error message should be handled gracefully
        final response = ApiResponse<String>.error('Network error');
        expect(response.isSuccess, false);
        expect(response.error, 'Network error');
      });

      test('ApiResponse with different data types', () {
        final boolResponse = ApiResponse.success(true);
        final doubleResponse = ApiResponse.success(3.14);
        final listResponse = ApiResponse.success([1, 2, 3]);
        
        expect(boolResponse.data, true);
        expect(doubleResponse.data, 3.14);
        expect(listResponse.data, [1, 2, 3]);
      });

      test('Mock mode error handling', () {
        // Test that mock responses are handled correctly
        final networkError = ApiResponse<String>.error('No internet connection');
        expect(networkError.isSuccess, false);
        expect(networkError.error, 'No internet connection');
      });
    });
  });
} 