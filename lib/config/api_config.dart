// lib/config/api_config.dart
class ApiConfig {
  // Base URLs for different environments
  static const String localUrl = 'http://127.0.0.1:9000/api';
  static const String stagingUrl = 'https://staging-api.arrahnu-auction.com/api';
  static const String productionUrl = 'https://api.arrahnu-auction.com/api';
  
  // Current environment - change this to switch environments
  static const String _environment = 'local'; // Options: 'local', 'staging', 'production'
  
  // Get the appropriate API URL based on environment
  static String get apiUrl {
    switch (_environment) {
      case 'production':
        return productionUrl;
      case 'staging':
        return stagingUrl;
      case 'local':
      default:
        return localUrl;
    }
  }
  
  // API timeout configuration
  static const Duration timeout = Duration(seconds: 30);
  
  // API versioning
  static const String apiVersion = 'v1';
  
  // Common headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers with authentication token
  static Map<String, String> headersWithAuth(String? token) => {
    ...defaultHeaders,
    if (token != null) 'Authorization': 'Bearer $token',
  };
} 