import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'watchlist_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'storage_service.dart';
import '../models/user.dart';
import '../config/api_config.dart';

class UserService {
  // Basic auth endpoints - keeping only login/register related
  static const String _authProfileEndpoint = '/auth/profile';

  // Get storage service
  static StorageService get _storageService => Get.find<StorageService>();

  // Get basic user profile (AuthController) - minimal implementation for login/register
  static Future<ApiResponse<UserProfileResponse>> getBasicUserProfile(String token) async {
    final response = await ApiService.get<Map<String, dynamic>>(
      _authProfileEndpoint,
      token: token,
    );

    if (response.isSuccess && response.data != null) {
      try {
        // Create a simplified UserProfileResponse from basic profile data
        final userData = response.data!['data']?['user'] ?? response.data!['user'] ?? {};
        
        final userProfile = UserProfile(
          id: userData['id']?.toString() ?? '',
          fullName: userData['full_name'] ?? '',
          username: userData['username'] ?? '',
          email: userData['email'] ?? '',
          phoneNumber: userData['phone_number'],
          role: userData['role'] ?? 'bidder',
          status: userData['status'] ?? 'active',
          avatarUrl: userData['avatar_url'],
          isEmailVerified: userData['is_email_verified'] ?? false,
          isPhoneVerified: userData['is_phone_verified'] ?? false,
          twoFactorAuth: userData['2fa'] ?? false,
          createdAt: userData['created_at'] ?? '',
          lastLoginAt: userData['last_login_at'],
        );
        
        // Create empty statistics and profile completion
        final statistics = UserStatistics(
          totalBids: 0,
          activeBids: 0,
          successfulBids: 0,
          totalSpent: 0,
          accountAgeDays: 0,
        );
        
        final profileCompletion = ProfileCompletion(
          percentage: 0,
          completedFields: 0,
          totalFields: 0,
          missingFields: [],
        );
        
        final profileResponse = UserProfileResponse(
          user: userProfile,
          statistics: statistics,
          profileCompletion: profileCompletion,
        );
        
        // Update user in storage service
        final user = _convertToUser(userProfile);
        _storageService.saveUser(user);
        
        return ApiResponse.success(profileResponse);
      } catch (e) {
        return ApiResponse.error('Error parsing profile data: $e');
      }
    } else {
      return ApiResponse.error(response.error ?? 'Failed to fetch user profile');
    }
  }

  // Helper method to convert UserProfile to User
  static User _convertToUser(UserProfile profile) {
    return User(
      id: profile.id,
      fullName: profile.fullName,
      email: profile.email,
      username: profile.username,
      phoneNumber: profile.phoneNumber,
      role: profile.role,
      status: profile.status,
      isEmailVerified: profile.isEmailVerified,
      isPhoneVerified: profile.isPhoneVerified,
      isVerified: profile.isVerified ?? profile.isEmailVerified,
      createdAt: profile.createdAt,
      lastLoginAt: profile.lastLoginAt,
      icNumber: profile.icNumber,
      address1: profile.address1,
      address2: profile.address2,
      address3: profile.address3,
      postcode: profile.postcode,
      city: profile.city,
      state: profile.state,
      country: profile.country,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      nationality: profile.nationality,
      occupation: profile.occupation,
    );
  }
}

// Helper function to get minimum of two integers
int min(int a, int b) {
  return a < b ? a : b;
}

// User Profile Response Model (updated to match documented format)
class UserProfileResponse {
  final UserProfile user;
  final UserStatistics statistics;
  final ProfileCompletion profileCompletion;

  UserProfileResponse({
    required this.user,
    required this.statistics,
    required this.profileCompletion,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return UserProfileResponse(
      user: UserProfile.fromJson(data['user'] ?? {}),
      statistics: UserStatistics.fromJson(data['statistics'] ?? {}),
      profileCompletion: ProfileCompletion.fromJson(data['profile_completion'] ?? {}),
    );
  }

  // Convenience getters for backwards compatibility
  String get fullName => user.fullName;
  String get email => user.email;
  String get memberSince => user.createdAt;
  bool get isVerified => user.isEmailVerified;
}

// User Profile Model (comprehensive profile information)
class UserProfile {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? gender;
  final String? nationality;
  final String? occupation;
  final String role;
  final String status;
  final String? avatarUrl;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool twoFactorAuth;
  final String createdAt;
  final String? lastLoginAt;
  // Address fields for backwards compatibility
  final String? icNumber;
  final String? address1;
  final String? address2;
  final String? address3;
  final String? postcode;
  final String? city;
  final String? state;
  final String? country;
  // Additional user fields
  final String? memberSince;
  final double? balance;
  final bool? isVerified;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.occupation,
    required this.role,
    required this.status,
    this.avatarUrl,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.twoFactorAuth = false,
    required this.createdAt,
    this.lastLoginAt,
    this.icNumber,
    this.address1,
    this.address2,
    this.address3,
    this.postcode,
    this.city,
    this.state,
    this.country,
    this.memberSince,
    this.balance,
    this.isVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      nationality: json['nationality'],
      occupation: json['occupation'],
      role: json['role'] ?? 'bidder',
      status: json['status'] ?? 'active',
      avatarUrl: json['avatar_url'],
      isEmailVerified: json['is_email_verified'] ?? false,
      isPhoneVerified: json['is_phone_verified'] ?? false,
      twoFactorAuth: json['2fa'] ?? false,
      createdAt: json['created_at'] ?? '',
      lastLoginAt: json['last_login_at'],
      icNumber: json['ic_number'],
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      postcode: json['postcode'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      memberSince: json['member_since'],
      balance: json['balance']?.toDouble(),
      isVerified: json['is_verified'],
    );
  }
  
  @override
  String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, email: $email, role: $role, status: $status, isEmailVerified: $isEmailVerified)';
  }
}

// User Statistics Model
class UserStatistics {
  final int totalBids;
  final int activeBids;
  final int successfulBids;
  final double totalSpent;
  final int accountAgeDays;
  final String? lastBidDate;

  UserStatistics({
    required this.totalBids,
    required this.activeBids,
    required this.successfulBids,
    required this.totalSpent,
    required this.accountAgeDays,
    this.lastBidDate,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalBids: json['total_bids'] ?? 0,
      activeBids: json['active_bids'] ?? 0,
      successfulBids: json['successful_bids'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      accountAgeDays: json['account_age_days'] ?? 0,
      lastBidDate: json['last_bid_date'],
    );
  }

  // Convenience getters for backwards compatibility
  int get watchlistItems => 0; // Will be populated from actual watchlist service
  int get wonAuctions => successfulBids;
  int get participatedAuctions => totalBids;
}

// Profile Completion Model
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
      missingFields: List<String>.from(json['missing_fields'] ?? []),
    );
  }
}

// Bidding Activity Response Model
class BiddingActivityResponse {
  final String period;
  final BiddingStatistics statistics;
  final List<DailyActivity> dailyActivity;
  final List<RecentBid> recentBids;

  BiddingActivityResponse({
    required this.period,
    required this.statistics,
    required this.dailyActivity,
    required this.recentBids,
  });

  factory BiddingActivityResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BiddingActivityResponse(
      period: data['period'] ?? '',
      statistics: BiddingStatistics.fromJson(data['statistics'] ?? {}),
      dailyActivity: (data['daily_activity'] as List<dynamic>? ?? [])
          .map((activity) => DailyActivity.fromJson(activity))
          .toList(),
      recentBids: (data['recent_bids'] as List<dynamic>? ?? [])
          .map((bid) => RecentBid.fromJson(bid))
          .toList(),
    );
  }
}

// Bidding Statistics Model
class BiddingStatistics {
  final int totalBids;
  final int uniqueAuctions;
  final double totalAmountBid;
  final double averageBid;
  final int winningBids;
  final int successfulBids;

  BiddingStatistics({
    required this.totalBids,
    required this.uniqueAuctions,
    required this.totalAmountBid,
    required this.averageBid,
    required this.winningBids,
    required this.successfulBids,
  });

  factory BiddingStatistics.fromJson(Map<String, dynamic> json) {
    return BiddingStatistics(
      totalBids: json['total_bids'] ?? 0,
      uniqueAuctions: json['unique_auctions'] ?? 0,
      totalAmountBid: (json['total_amount_bid'] ?? 0).toDouble(),
      averageBid: (json['average_bid'] ?? 0).toDouble(),
      winningBids: json['winning_bids'] ?? 0,
      successfulBids: json['successful_bids'] ?? 0,
    );
  }
}

// Daily Activity Model
class DailyActivity {
  final String date;
  final int bidsCount;
  final double totalAmount;

  DailyActivity({
    required this.date,
    required this.bidsCount,
    required this.totalAmount,
  });

  factory DailyActivity.fromJson(Map<String, dynamic> json) {
    return DailyActivity(
      date: json['date'] ?? '',
      bidsCount: json['bids_count'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
    );
  }
}

// Recent Bid Model
class RecentBid {
  final String id;
  final double amount;
  final String collateralTitle;
  final String auctionStatus;
  final bool isWinning;
  final String createdAt;

  RecentBid({
    required this.id,
    required this.amount,
    required this.collateralTitle,
    required this.auctionStatus,
    required this.isWinning,
    required this.createdAt,
  });

  factory RecentBid.fromJson(Map<String, dynamic> json) {
    return RecentBid(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      collateralTitle: json['collateral_title'] ?? '',
      auctionStatus: json['auction_status'] ?? '',
      isWinning: json['is_winning'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

 