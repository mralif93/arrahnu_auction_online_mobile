import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  // Use the API config for base URL
  static String get currentBaseUrl => ApiConfig.apiUrl;

  // Headers with authentication token
  static Map<String, String> _headersWithAuth(String? token) => ApiConfig.headersWithAuth(token);

  // GET request with proper error handling
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    String? token,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$currentBaseUrl$endpoint');
      final uriWithQuery = queryParams != null 
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await http
          .get(uriWithQuery, headers: _headersWithAuth(token))
          .timeout(ApiConfig.timeout);
      
      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('No internet connection. Please check your network and try again.');
    } on HttpException catch (e) {
      return ApiResponse.error('Network error: ${e.message}');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (_) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // POST request with proper error handling
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$currentBaseUrl$endpoint');
      
      final response = await http
          .post(
            uri,
            headers: _headersWithAuth(token),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('No internet connection. Please check your network and try again.');
    } on HttpException catch (e) {
      return ApiResponse.error('Network error: ${e.message}');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (_) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // PUT request with proper error handling
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$currentBaseUrl$endpoint');
      
      final response = await http
          .put(
            uri,
            headers: _headersWithAuth(token),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('No internet connection. Please check your network and try again.');
    } on HttpException catch (e) {
      return ApiResponse.error('Network error: ${e.message}');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (_) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // DELETE request with proper error handling
  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$currentBaseUrl$endpoint');
      
      final response = await http
          .delete(
            uri,
            headers: _headersWithAuth(token),
          )
          .timeout(ApiConfig.timeout);
      
      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('No internet connection. Please check your network and try again.');
    } on HttpException catch (e) {
      return ApiResponse.error('Network error: ${e.message}');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (_) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Handle HTTP response with proper error checking
  static ApiResponse<T> _handleResponse<T>(http.Response response) {
    try {
      final responseBody = response.body;
      
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);
      
      // Check for successful response (200-299 status codes)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final bool success = jsonResponse['success'] ?? true;
        if (success) {
          return ApiResponse.success(jsonResponse as T);
        } else {
          final String message = jsonResponse['message'] ?? 'Request failed';
          return ApiResponse.error(message);
        }
      } else {
        // Handle different error status codes
        final String message = jsonResponse['message'] ?? 'Request failed';
        switch (response.statusCode) {
          case 401:
            return ApiResponse.error('Unauthorized - Please login again');
          case 403:
            return ApiResponse.error('Access denied');
          case 404:
            return ApiResponse.error('Resource not found');
          case 422:
            return ApiResponse.error(message, errors: jsonResponse['errors']);
          case 429:
            return ApiResponse.error('Too many requests - Please try again later');
          case 500:
            return ApiResponse.error('Server error - Please try again later');
          default:
            return ApiResponse.error(message);
        }
      }
    } catch (_) {
      return ApiResponse.error('Failed to parse server response');
    }
  }
}

// API Response wrapper class
class ApiResponse<T> {
  final T? data;
  final String? error;
  final Map<String, dynamic>? errors;
  final bool isSuccess;

  ApiResponse._({
    this.data,
    this.error,
    this.errors,
    required this.isSuccess,
  });

  // Create a success response
  factory ApiResponse.success(T data) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
    );
  }

  // Create an error response
  factory ApiResponse.error(String message, {Map<String, dynamic>? errors}) {
    return ApiResponse._(
      error: message,
      errors: errors,
      isSuccess: false,
    );
  }
} 