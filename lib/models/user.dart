class User {
  final String id;
  final String fullName;
  final String email;
  final String? username;
  final String? phoneNumber;
  final String role;
  final String status;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isVerified;
  final String createdAt;
  final String? lastLoginAt;
  final double? balance;
  final String? icNumber;
  final String? address1;
  final String? address2;
  final String? address3;
  final String? postcode;
  final String? city;
  final String? state;
  final String? country;
  final String? dateOfBirth;
  final String? gender;
  final String? nationality;
  final String? occupation;
  final String? avatarUrl;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.createdAt,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isVerified,
    this.username,
    this.phoneNumber,
    this.role = 'bidder',
    this.status = 'active',
    this.icNumber,
    this.address1,
    this.address2,
    this.address3,
    this.postcode,
    this.city,
    this.state,
    this.country,
    this.lastLoginAt,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.occupation,
    this.avatarUrl,
    this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['created_at'] ?? '',
      isEmailVerified: json['is_email_verified'] ?? false,
      isPhoneVerified: json['is_phone_verified'] ?? false,
      isVerified: json['is_verified'] ?? false,
      username: json['username'],
      phoneNumber: json['phone_number'],
      role: json['role'] ?? 'bidder',
      status: json['status'] ?? 'active',
      icNumber: json['ic_number'],
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      postcode: json['postcode'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      lastLoginAt: json['last_login_at'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      nationality: json['nationality'],
      occupation: json['occupation'],
      avatarUrl: json['avatar_url'],
      balance: json['balance']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'username': username,
      'phone_number': phoneNumber,
      'role': role,
      'status': status,
      'created_at': createdAt,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'is_verified': isVerified,
      'ic_number': icNumber,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'postcode': postcode,
      'city': city,
      'state': state,
      'country': country,
      'last_login_at': lastLoginAt,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'nationality': nationality,
      'occupation': occupation,
      'avatar_url': avatarUrl,
      'balance': balance,
    };
  }

  // Helper methods
  bool get isActive => status == 'active';
  bool get isBidder => role == 'bidder';
  bool get isAdmin => role == 'admin';
  bool get isEmailConfirmed => isEmailVerified;

  User copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
    String? nationality,
    String? occupation,
    String? role,
    String? status,
    String? avatarUrl,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isVerified,
    String? createdAt,
    String? lastLoginAt,
    double? balance,
    String? icNumber,
    String? address1,
    String? address2,
    String? address3,
    String? postcode,
    String? city,
    String? state,
    String? country,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      occupation: occupation ?? this.occupation,
      role: role ?? this.role,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      balance: balance ?? this.balance,
      icNumber: icNumber ?? this.icNumber,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      address3: address3 ?? this.address3,
      postcode: postcode ?? this.postcode,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }
} 