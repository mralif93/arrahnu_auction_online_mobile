import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/auth/login_request.dart';
import '../models/auth/register_request.dart';
import '../models/auth/auth_response.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: ApiConfig.headers,
        body: jsonEncode(request.toJson()),
      );

      final responseData = jsonDecode(response.body);

      print('Response: ${responseData}');
      
      // Check if the response has the expected structure
      if (responseData is Map<String, dynamic>) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: 'Invalid response format from server',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        return AuthResponse(
          success: false,
          message: 'Invalid response format from server',
        );
      } else if (e is http.ClientException) {
        return AuthResponse(
          success: false,
          message: 'Network error: Unable to connect to server',
        );
      } else {
        return AuthResponse(
          success: false,
          message: 'An unexpected error occurred: ${e.toString()}',
        );
      }
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
        headers: ApiConfig.headers,
        body: jsonEncode(request.toJson()),
      );

      final responseData = jsonDecode(response.body);
      
      // Check if the response has the expected structure
      if (responseData is Map<String, dynamic>) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: 'Invalid response format from server',
        );
      }
    } catch (e) {
      if (e is FormatException) {
        return AuthResponse(
          success: false,
          message: 'Invalid response format from server',
        );
      } else if (e is http.ClientException) {
        return AuthResponse(
          success: false,
          message: 'Network error: Unable to connect to server',
        );
      } else {
        return AuthResponse(
          success: false,
          message: 'An unexpected error occurred: ${e.toString()}',
        );
      }
    }
  }

  void dispose() {
    _client.close();
  }
} 