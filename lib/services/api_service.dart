import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class ApiService {
  final http.Client _client = http.Client();

  // Test connection method
  Future<bool> testConnection() async {
    try {
      final response = await _client.get(
        Uri.parse(ListEndpoints.auctions),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Generic GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: ApiConfig.timeoutDuration));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      ).timeout(Duration(seconds: ApiConfig.timeoutDuration));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Public List Methods with query parameters
  Future<Map<String, dynamic>> getAccounts({String? branchId}) async {
    final endpoint = branchId != null 
      ? '${ListEndpoints.accounts}?branch_id=$branchId'
      : ListEndpoints.accounts;
    return get(endpoint);
  }

  Future<Map<String, dynamic>> getBranches({String? region}) async {
    final endpoint = region != null 
      ? '${ListEndpoints.branches}?region=$region'
      : ListEndpoints.branches;
    return get(endpoint);
  }

  Future<Map<String, dynamic>> getAuctions() async {
    return get(ListEndpoints.auctions);
  }

  Future<Map<String, dynamic>> getCollaterals() async {
    return get(ListEndpoints.collaterals);
  }

  Future<Map<String, dynamic>> getActiveAuctions() async {
    return get(AuctionEndpoints.active);
  }

  // Authentication Methods
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    return post(AuthEndpoints.register, userData);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return post(AuthEndpoints.login, {
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> verifyEmail(String token) async {
    return get(AuthEndpoints.verifyEmail(token));
  }

  Future<Map<String, dynamic>> resendVerification(String email) async {
    return post(AuthEndpoints.resendVerification, {
      'email': email,
    });
  }

  Future<Map<String, dynamic>> checkVerificationStatus(String email) async {
    return post(AuthEndpoints.verificationStatus, {
      'email': email,
    });
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return post(AuthEndpoints.forgotPassword, {
      'email': email,
    });
  }

  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    return post(AuthEndpoints.resetPassword, {
      'token': token,
      'new_password': newPassword,
    });
  }

  void dispose() {
    _client.close();
  }
} 