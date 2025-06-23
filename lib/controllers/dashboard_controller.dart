import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/user.dart';

class DashboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Observable variables
  final isLoading = false.obs;
  final isLoadingProfile = false.obs;
  final isLoadingStats = false.obs;
  final isLoadingBids = false.obs;
  final isLoadingWatchlist = false.obs;
  final user = Rx<User?>(null);
  final errorMessage = ''.obs;
  final userName = ''.obs;
  
  // Dashboard stats
  final activeBids = 0.obs;
  final watchlistItems = 0.obs;
  final wonAuctions = 0.obs;
  
  // Data lists
  final recentBids = <UserBid>[].obs;
  final watchlistAuctions = <WatchlistItem>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
    _loadDashboardData();
  }
  
  void _loadUserFromStorage() {
    final storedUser = _storageService.getUser();
    if (storedUser != null) {
      user.value = storedUser;
    }
  }
  
  void _loadDashboardData() {
    // Load real data from API
    _loadUserBids();
    _loadUserWatchlist();
    _updateStats();
  }
  
  void _loadUserBids() {
    // Load user bids from API
    recentBids.value = [];
  }
  
  void _loadUserWatchlist() {
    // Load user watchlist from API
    watchlistAuctions.value = [];
  }
  
  void _updateStats() {
    // Update stats from real data
    activeBids.value = recentBids.where((bid) => bid.status == 'winning').length;
    watchlistItems.value = watchlistAuctions.length;
    wonAuctions.value = 0;
  }
  
  // Navigation methods (implement navigation as needed)
  void onProfileTap() {}
  void onWalletTap() {}
  void onBidsHistoryTap() {}
  void onLogoutTap() {}
  void onWatchlistTap() {}
  void onSettingsTap() {}
  void onBidItemTap(UserBid bid) {}
  void onWatchlistItemTap(WatchlistItem item) {}

  // Refresh methods
  Future<void> refreshDashboard() async {
    // Implement dashboard refresh logic here
    // For example: reload user data, refresh stats, etc.
  }

  void removeFromWatchlist(String auctionId) {
    watchlistAuctions.removeWhere((item) => item.id == auctionId);
    // Optionally update stats if needed
  }

  String formatCurrency(double amount) {
    return 'RM ${amount.toStringAsFixed(2)}';
  }

  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'winning':
        return Colors.green;
      case 'outbid':
        return Colors.orange;
      case 'lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    return status.toUpperCase();
  }

  StorageService get storageService => _storageService;
}
