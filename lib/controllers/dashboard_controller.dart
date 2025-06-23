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
  final recentBids = <Map<String, dynamic>>[].obs;
  final watchlistAuctions = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }
  
  Future<void> loadDashboard() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      await Future.wait([
        loadUserProfile(),
        loadStats(),
        loadRecentBids(),
        loadWatchlist(),
      ]);
    } catch (e) {
      errorMessage.value = 'Failed to load dashboard';
      print('Error loading dashboard: $e');
    }
    
    isLoading.value = false;
  }
  
  Future<void> loadUserProfile() async {
    isLoadingProfile.value = true;
    
    try {
      final userData = _storageService.getUser();
      if (userData != null) {
        user.value = User.fromJson(userData);
        userName.value = user.value?.fullName ?? 'User';
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
    
    isLoadingProfile.value = false;
  }
  
  Future<void> loadStats() async {
    isLoadingStats.value = true;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Dummy stats
      activeBids.value = 3;
      watchlistItems.value = 5;
      wonAuctions.value = 2;
    } catch (e) {
      print('Error loading stats: $e');
    }
    
    isLoadingStats.value = false;
  }
  
  Future<void> loadRecentBids() async {
    isLoadingBids.value = true;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Dummy bids
      recentBids.value = [
        {
          'id': 'BID001',
          'itemId': 'ITEM001',
          'itemTitle': 'Gold Necklace 916',
          'amount': 5500.0,
          'status': 'winning',
          'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toString(),
          'itemImage': 'assets/images/items/necklace.jpg',
        },
        {
          'id': 'BID002',
          'itemId': 'ITEM002',
          'itemTitle': 'Gold Ring 750',
          'amount': 3200.0,
          'status': 'outbid',
          'createdAt': DateTime.now().subtract(const Duration(hours: 5)).toString(),
          'itemImage': 'assets/images/items/ring.jpg',
        },
      ];
    } catch (e) {
      print('Error loading bids: $e');
    }
    
    isLoadingBids.value = false;
  }
  
  Future<void> loadWatchlist() async {
    isLoadingWatchlist.value = true;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Dummy watchlist
      watchlistAuctions.value = [
        {
          'id': 'ITEM003',
          'title': 'Gold Bracelet 916',
          'currentBid': 4500.0,
          'endTime': DateTime.now().add(const Duration(hours: 12)).toString(),
          'status': 'ongoing',
          'image': 'assets/images/items/bracelet.jpg',
        },
        {
          'id': 'ITEM004',
          'title': 'Gold Chain 750',
          'currentBid': 3800.0,
          'endTime': DateTime.now().add(const Duration(hours: 24)).toString(),
          'status': 'upcoming',
          'image': 'assets/images/items/chain.jpg',
        },
      ];
    } catch (e) {
      print('Error loading watchlist: $e');
    }
    
    isLoadingWatchlist.value = false;
  }
  
  Future<void> refreshDashboard() async {
    await loadDashboard();
  }
  
  String formatCurrency(double amount) {
    return 'RM ${amount.toStringAsFixed(2)}';
  }
  
  String formatTimeAgo(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
  
  String formatTimeLeft(String dateStr) {
    try {
      final endTime = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = endTime.difference(now);
      
      if (difference.isNegative) {
        return 'Ended';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d left';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h left';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m left';
      } else {
        return 'Ending soon';
      }
    } catch (e) {
      return 'Unknown';
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
      case 'won':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
  
  void onBidItemTap(Map<String, dynamic> bid) {
    // Navigate to item detail
    Get.toNamed('/item/${bid['itemId']}');
  }
  
  void onWatchlistItemTap(Map<String, dynamic> item) {
    // Navigate to item detail
    Get.toNamed('/item/${item['id']}');
  }
  
  void onSettingsTap() {
    Get.toNamed('/settings');
  }

  void onProfileTap() {
    Get.toNamed('/profile');
  }

  void onWalletTap() {
    Get.toNamed('/wallet');
  }

  void onBidsHistoryTap() {
    Get.toNamed('/bids/history');
  }

  void onWatchlistTap() {
    Get.toNamed('/watchlist');
  }

  void onLogoutTap() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Clear user data
      await _storageService.clearUser();
      // Navigate to login
      Get.offAllNamed('/login');
    }
  }
}
