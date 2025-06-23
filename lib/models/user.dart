// User Model (updated to match documented format)
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
  
  // Enhanced profile fields
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
      isVerified: json['is_verified'] ?? json['is_email_verified'] ?? false,
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
  
  // Copy with method for immutable updates
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
  
  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email, role: $role, status: $status, isVerified: $isVerified)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

// User Statistics model
class UserStatistics {
  final int totalBids;
  final int activeBids;
  final int successfulBids;
  final double totalSpent;
  final int accountAgeDays;

  UserStatistics({
    required this.totalBids,
    required this.activeBids,
    required this.successfulBids,
    required this.totalSpent,
    required this.accountAgeDays,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalBids: json['total_bids'] ?? 0,
      activeBids: json['active_bids'] ?? 0,
      successfulBids: json['successful_bids'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      accountAgeDays: json['account_age_days'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_bids': totalBids,
      'active_bids': activeBids,
      'successful_bids': successfulBids,
      'total_spent': totalSpent,
      'account_age_days': accountAgeDays,
    };
  }
}

// Profile Completion model
class ProfileCompletion {
  final int percentage;
  final int completedFields;
  final int totalFields;
  final List<String> missingFields;

  ProfileCompletion({
    required this.percentage,
    required this.completedFields,
    required this.totalFields,
    required this.missingFields,
  });

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) {
    return ProfileCompletion(
      percentage: json['percentage'] ?? 0,
      completedFields: json['completed_fields'] ?? 0,
      totalFields: json['total_fields'] ?? 0,
      missingFields: (json['missing_fields'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'completed_fields': completedFields,
      'total_fields': totalFields,
      'missing_fields': missingFields,
    };
  }
}

// Bidding Activity model
class BiddingActivity {
  final String id;
  final String collateralId;
  final String collateralName;
  final double bidAmount;
  final String bidStatus;
  final String createdAt;

  BiddingActivity({
    required this.id,
    required this.collateralId,
    required this.collateralName,
    required this.bidAmount,
    required this.bidStatus,
    required this.createdAt,
  });

  factory BiddingActivity.fromJson(Map<String, dynamic> json) {
    return BiddingActivity(
      id: json['id']?.toString() ?? '',
      collateralId: json['collateral_id']?.toString() ?? '',
      collateralName: json['collateral_name'] ?? '',
      bidAmount: (json['bid_amount'] ?? 0).toDouble(),
      bidStatus: json['bid_status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collateral_id': collateralId,
      'collateral_name': collateralName,
      'bid_amount': bidAmount,
      'bid_status': bidStatus,
      'created_at': createdAt,
    };
  }
}

// Bidding Activity Response model
class BiddingActivityResponse {
  final List<BiddingActivity> activities;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  BiddingActivityResponse({
    required this.activities,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory BiddingActivityResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    
    return BiddingActivityResponse(
      activities: (data['activities'] as List<dynamic>?)
          ?.map((e) => BiddingActivity.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      totalCount: data['total_count'] ?? 0,
      currentPage: data['current_page'] ?? 1,
      totalPages: data['total_pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activities': activities.map((e) => e.toJson()).toList(),
      'total_count': totalCount,
      'current_page': currentPage,
      'total_pages': totalPages,
    };
  }
}

// Watchlist Item model
class WatchlistItem {
  final String id;
  final String collateralId;
  final String collateralName;
  final String imageUrl;
  final double currentBid;
  final String endTime;
  final bool isActive;

  WatchlistItem({
    required this.id,
    required this.collateralId,
    required this.collateralName,
    required this.imageUrl,
    required this.currentBid,
    required this.endTime,
    required this.isActive,
  });

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      id: json['id']?.toString() ?? '',
      collateralId: json['collateral_id']?.toString() ?? '',
      collateralName: json['collateral_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      currentBid: (json['current_bid'] ?? 0).toDouble(),
      endTime: json['end_time'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collateral_id': collateralId,
      'collateral_name': collateralName,
      'image_url': imageUrl,
      'current_bid': currentBid,
      'end_time': endTime,
      'is_active': isActive,
    };
  }
}

// Watchlist Response model
class WatchlistResponse {
  final List<WatchlistItem> items;
  final int totalCount;

  WatchlistResponse({
    required this.items,
    required this.totalCount,
  });

  factory WatchlistResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    
    return WatchlistResponse(
      items: (data['items'] as List<dynamic>?)
          ?.map((e) => WatchlistItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      totalCount: data['total_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total_count': totalCount,
    };
  }
}

// Additional placeholder classes for compilation
class UserBid {
  final String id;
  final double amount;
  final String status;
  final String createdAt;
  final String auctionTitle;
  
  UserBid({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.auctionTitle,
  });
  
  // Convenience getters for backwards compatibility
  double get bidAmount => amount;
  String get bidTime => createdAt;
  String get auctionId => id;
}

class AuctionItem {
  final String id;
  final String title;
  final String description;
  final double currentBid;
  final String timeLeft;
  final String category;
  
  AuctionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.currentBid,
    required this.timeLeft,
    required this.category,
  });
}

enum AuctionStatus { beforeStart, active, ended }

class TestResult {
  final String name;
  final String endpoint;
  final String method;
  final bool success;
  final String message;
  
  TestResult({
    required this.name,
    required this.endpoint,
    required this.method,
    required this.success,
    required this.message,
  });
} 