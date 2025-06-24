class AuthResponse {
  final bool success;
  final String message;
  final AuthData? data;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }
}

class AuthData {
  final UserData user;
  final String token;
  final String token_type;

  AuthData({
    required this.user,
    required this.token,
    required this.token_type,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: UserData.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
      token_type: json['token_type'] ?? '',
    );
  }
}

class UserData {
  final String id;
  final String full_name;
  final String username;
  final String email;
  final String phone_number;
  final String role;
  final bool is_admin;
  final String status;

  UserData({
    required this.id,
    required this.full_name,
    required this.username,
    required this.email,
    required this.phone_number,
    required this.role,
    required this.is_admin,
    required this.status,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      full_name: json['full_name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone_number: json['phone_number']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      is_admin: json['is_admin'] ?? false,
      status: json['status']?.toString() ?? '',
    );
  }
} 