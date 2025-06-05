import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';

class DashboardController extends GetxController {
  // User information
  var userName = "John Doe".obs;
  var userEmail = "john.doe@example.com".obs;
  var userBalance = "RM 2,500.00".obs;
  var memberSince = "January 2024".obs;

  // Dashboard stats
  var activeBids = 5.obs;
  var watchlistItems = 12.obs;
  var wonAuctions = 3.obs;
  var totalSpent = "RM 15,750.00".obs;

  // Recent activities
  var recentBids = <Map<String, dynamic>>[
    {
      'item': 'Gold Necklace 18K',
      'currentBid': 'RM 850.00',
      'timeLeft': '2h 15m',
      'status': 'leading',
      'image': 'jewelry',
    },
    {
      'item': 'Diamond Ring',
      'currentBid': 'RM 1,200.00',
      'timeLeft': '5h 30m',
      'status': 'outbid',
      'image': 'ring',
    },
    {
      'item': 'Silver Watch',
      'currentBid': 'RM 450.00',
      'timeLeft': '1d 3h',
      'status': 'leading',
      'image': 'watch',
    },
  ].obs;

  // Watchlist items
  var watchlistAuctions = <Map<String, dynamic>>[
    {
      'item': 'Emerald Earrings',
      'currentBid': 'RM 650.00',
      'timeLeft': '3h 45m',
      'image': 'earrings',
    },
    {
      'item': 'Pearl Bracelet',
      'currentBid': 'RM 320.00',
      'timeLeft': '6h 20m',
      'image': 'bracelet',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Simulate loading user data
    // In real app, this would fetch from API
    // Don't show feedback during initialization to avoid test issues
  }

  void onProfileTap() {
    // Navigate to profile page
    // TODO: Implement profile navigation
  }

  void onWalletTap() {
    // Navigate to wallet page
    // TODO: Implement wallet navigation
  }

  void onBidsHistoryTap() {
    // Navigate to bids history page
    // TODO: Implement bids history navigation
  }

  void onWatchlistTap() {
    // Navigate to watchlist page
    // TODO: Implement watchlist navigation
  }

  void onSettingsTap() {
    // Navigate to settings page
    // TODO: Implement settings navigation
  }

  void onLogoutTap() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              // Logout using AccountController
              Get.find<AccountController>().logout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void onBidItemTap(Map<String, dynamic> item) {
    // Navigate to bid item details
    // TODO: Implement bid item navigation
  }

  void onWatchlistItemTap(Map<String, dynamic> item) {
    // Navigate to watchlist item details
    // TODO: Implement watchlist item navigation
  }
}
