import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../config/api_config.dart';
import '../models/auth_models.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService = Get.find<StorageService>();
  
  // API endpoints - keeping only login/register related
  static const String _loginEndpoint = '/auth/login';
  static const String _registerEndpoint = '/auth/register';
  static const String _logoutEndpoint = '/auth/logout';

  // Login user
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiUrl}$_loginEndpoint'),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConfig.timeout);
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['data']['token'];
        final user = User.fromJson(data['data']['user']);
        
        // Save token using StorageService instead of FlutterSecureStorage
        await _storageService.saveAuthToken(token);
        await _storageService.saveUser(user);
        
        return AuthResult.success(user, token);
      } else if (response.statusCode == 403) {
        // Handle email verification and approval status
        final errorCode = data['error_code'];
        final verificationStatus = data['verification_status'];
        final approvalStatus = data['approval_status'];
        
        String message = data['message'] ?? 'Login failed';
        
        if (errorCode == 'EMAIL_NOT_VERIFIED') {
          if (verificationStatus != null) {
            final emailVerified = verificationStatus['email_verified'] ?? false;
            final isApproved = approvalStatus['is_approved'] ?? false;
            
            if (!emailVerified && !isApproved) {
              message = 'Please verify your email address and wait for admin approval before logging in.';
            } else if (!emailVerified) {
              message = 'Please verify your email address before logging in.';
            } else if (!isApproved) {
              message = 'Your account is pending admin approval. Please wait for approval before logging in.';
            }
          }
        }
        
        return AuthResult.failure(message, 
          needsEmailVerification: errorCode == 'EMAIL_NOT_VERIFIED',
          verificationStatus: verificationStatus,
          approvalStatus: approvalStatus
        );
      } else {
        return AuthResult.failure(data['message'] ?? 'Login failed');
      }
    } on SocketException {
      return AuthResult.failure('No internet connection');
    } on HttpException catch (e) {
      return AuthResult.failure('Network error: ${e.message}');
    } on FormatException {
      return AuthResult.failure('Invalid response format');
    } catch (e) {
      return AuthResult.failure('Network error: $e');
    }
  }

  // Register user
  Future<AuthResult> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiUrl}$_registerEndpoint'),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode(request.toJson()),
      ).timeout(ApiConfig.timeout);
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 && data['success'] == true) {
        final user = User.fromJson(data['data']['user']);
        return AuthResult.success(user, null);
      } else {
        final errors = data['errors'] as Map<String, dynamic>?;
        String errorMessage = data['message'] ?? 'Registration failed';
        
        // Format validation errors for better user experience
        if (errors != null) {
          final errorList = <String>[];
          errors.forEach((field, messages) {
            if (messages is List) {
              errorList.addAll(messages.map((msg) => msg.toString()));
            } else {
              errorList.add(messages.toString());
            }
          });
          if (errorList.isNotEmpty) {
            errorMessage = errorList.join('\n');
          }
        }
        
        return AuthResult.failure(errorMessage, errors: errors);
      }
    } on SocketException {
      return AuthResult.failure('No internet connection. Please check your network and try again.');
    } on HttpException catch (e) {
      return AuthResult.failure('Network error: ${e.message}');
    } on FormatException {
      return AuthResult.failure('Invalid response from server. Please try again.');
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: $e');
    }
  }

  // Get stored token from StorageService
  Future<String?> getToken() async {
    return _storageService.getAuthToken();
  }
  
  // Logout user - keeping this as it's related to login
  Future<bool> logout() async {
    try {
      final token = _storageService.getAuthToken();
      if (token != null) {
        await http.post(
          Uri.parse('${ApiConfig.apiUrl}$_logoutEndpoint'),
          headers: ApiConfig.headersWithAuth(token),
        ).timeout(ApiConfig.timeout);
      }
      
      await _storageService.clearAll();
      return true;
    } catch (e) {
      await _storageService.clearAll();
      return false;
    }
  }
  
  // Check if user is authenticated - keeping this as it's related to login
  bool isAuthenticated() {
    return _storageService.isLoggedIn;
  }
} 