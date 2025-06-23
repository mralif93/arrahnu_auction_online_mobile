class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:9000/api';
  
  // Add other API-related configurations here
  static const int timeoutDuration = 30; // seconds
}

class AuthEndpoints {
  static const String _base = '${ApiConfig.baseUrl}/auth';
  static const String register = '$_base/register';
  static const String login = '$_base/login';
  static String verifyEmail(String token) => '$_base/verify-email/$token';
  static const String resendVerification = '$_base/resend-verification';
  static const String verificationStatus = '$_base/verification-status';
  static const String forgotPassword = '$_base/forgot-password';
  static const String resetPassword = '$_base/reset-password';
}

class ListEndpoints {
  static const String _base = '${ApiConfig.baseUrl}/lists';
  static const String auctions = '$_base/auctions';
  static const String accounts = '$_base/accounts';
  static const String collaterals = '$_base/collaterals';
  static const String branches = '$_base/branches';
}

class AuctionEndpoints {
  static const String _base = '${ApiConfig.baseUrl}/auctions';
  static const String active = '$_base/active';
} 