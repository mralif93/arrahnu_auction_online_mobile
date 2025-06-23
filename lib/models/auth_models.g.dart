// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'user': instance.user,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      fullName: json['full_name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      passwordConfirmation: json['password_confirmation'] as String,
      phoneNumber: json['phone_number'] as String?,
      role: json['role'] as String? ?? 'bidder',
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'password_confirmation': instance.passwordConfirmation,
      'phone_number': instance.phoneNumber,
      'role': instance.role,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{'user': instance.user, 'message': instance.message};

UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => UpdateProfileRequest(
  fullName: json['full_name'] as String?,
  username: json['username'] as String?,
  email: json['email'] as String?,
  phoneNumber: json['phone_number'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  UpdateProfileRequest instance,
) => <String, dynamic>{
  'full_name': instance.fullName,
  'username': instance.username,
  'email': instance.email,
  'phone_number': instance.phoneNumber,
};

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  addresses: (json['addresses'] as List<dynamic>)
      .map((e) => Address.fromJson(e as Map<String, dynamic>))
      .toList(),
  primaryAddress: json['primary_address'] == null
      ? null
      : Address.fromJson(json['primary_address'] as Map<String, dynamic>),
  statistics: UserStatistics.fromJson(
    json['statistics'] as Map<String, dynamic>,
  ),
  profileCompletion: ProfileCompletion.fromJson(
    json['profile_completion'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'user': instance.user,
      'addresses': instance.addresses,
      'primary_address': instance.primaryAddress,
      'statistics': instance.statistics,
      'profile_completion': instance.profileCompletion,
    };

UserStatistics _$UserStatisticsFromJson(Map<String, dynamic> json) =>
    UserStatistics(
      totalBids: (json['total_bids'] as num).toInt(),
      wonAuctions: (json['won_auctions'] as num).toInt(),
      activeBids: (json['active_bids'] as num).toInt(),
      totalSpent: (json['total_spent'] as num).toDouble(),
    );

Map<String, dynamic> _$UserStatisticsToJson(UserStatistics instance) =>
    <String, dynamic>{
      'total_bids': instance.totalBids,
      'won_auctions': instance.wonAuctions,
      'active_bids': instance.activeBids,
      'total_spent': instance.totalSpent,
    };

ProfileCompletion _$ProfileCompletionFromJson(Map<String, dynamic> json) =>
    ProfileCompletion(
      percentage: (json['percentage'] as num).toDouble(),
      missingFields: (json['missing_fields'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProfileCompletionToJson(ProfileCompletion instance) =>
    <String, dynamic>{
      'percentage': instance.percentage,
      'missing_fields': instance.missingFields,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  id: json['id'] as String,
  type: json['type'] as String,
  addressLine1: json['address_line_1'] as String,
  addressLine2: json['address_line_2'] as String?,
  city: json['city'] as String,
  state: json['state'] as String,
  postalCode: json['postal_code'] as String,
  country: json['country'] as String,
  isPrimary: json['is_primary'] as bool,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'address_line_1': instance.addressLine1,
  'address_line_2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'postal_code': instance.postalCode,
  'country': instance.country,
  'is_primary': instance.isPrimary,
};
