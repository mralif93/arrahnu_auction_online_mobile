import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'auth_models.g.dart';

// Authentication result wrapper
class AuthResult {
  final bool success;
  final User? user;
  final String? token;
  final String? error;
  final String? message;
  final Map<String, dynamic>? errors;
  final bool needsEmailVerification;
  final Map<String, dynamic>? verificationStatus;
  final Map<String, dynamic>? approvalStatus;
  
  AuthResult.success(this.user, this.token, {this.message}) 
    : success = true, 
      error = null, 
      errors = null,
      needsEmailVerification = false,
      verificationStatus = null,
      approvalStatus = null;
  
  AuthResult.failure(this.error, {
    this.errors,
    this.needsEmailVerification = false,
    this.verificationStatus,
    this.approvalStatus,
  }) : success = false, 
       user = null, 
       token = null,
       message = null;
}

// Login response model
@JsonSerializable()
class LoginResponse {
  final String token;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  final User user;

  LoginResponse({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

// Register request model
@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'full_name')
  final String fullName;
  final String username;
  final String email;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String role;

  RegisterRequest({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phoneNumber,
    this.role = 'bidder',
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

// Register response model
@JsonSerializable()
class RegisterResponse {
  final User user;
  final String? message;

  RegisterResponse({
    required this.user,
    this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

// Update profile request model
@JsonSerializable()
class UpdateProfileRequest {
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? username;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  UpdateProfileRequest({
    this.fullName,
    this.username,
    this.email,
    this.phoneNumber,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}

// User profile with additional data
@JsonSerializable()
class UserProfile {
  final User user;
  final List<Address> addresses;
  @JsonKey(name: 'primary_address')
  final Address? primaryAddress;
  final UserStatistics statistics;
  @JsonKey(name: 'profile_completion')
  final ProfileCompletion profileCompletion;

  UserProfile({
    required this.user,
    required this.addresses,
    this.primaryAddress,
    required this.statistics,
    required this.profileCompletion,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

// User statistics model
@JsonSerializable()
class UserStatistics {
  @JsonKey(name: 'total_bids')
  final int totalBids;
  @JsonKey(name: 'won_auctions')
  final int wonAuctions;
  @JsonKey(name: 'active_bids')
  final int activeBids;
  @JsonKey(name: 'total_spent')
  final double totalSpent;

  UserStatistics({
    required this.totalBids,
    required this.wonAuctions,
    required this.activeBids,
    required this.totalSpent,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) => _$UserStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatisticsToJson(this);
}

// Profile completion model
@JsonSerializable()
class ProfileCompletion {
  final double percentage;
  @JsonKey(name: 'missing_fields')
  final List<String> missingFields;

  ProfileCompletion({
    required this.percentage,
    required this.missingFields,
  });

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) => _$ProfileCompletionFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileCompletionToJson(this);
}

// Address model for user profile
@JsonSerializable()
class Address {
  final String id;
  final String type;
  @JsonKey(name: 'address_line_1')
  final String addressLine1;
  @JsonKey(name: 'address_line_2')
  final String? addressLine2;
  final String city;
  final String state;
  @JsonKey(name: 'postal_code')
  final String postalCode;
  final String country;
  @JsonKey(name: 'is_primary')
  final bool isPrimary;

  Address({
    required this.id,
    required this.type,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isPrimary,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
} 