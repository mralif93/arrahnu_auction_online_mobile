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
      return AuthResponse.fromJson(responseData);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'An error occurred: ${e.toString()}',
      );
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
      return AuthResponse.fromJson(responseData);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }

  void dispose() {
    _client.close();
  }
} 