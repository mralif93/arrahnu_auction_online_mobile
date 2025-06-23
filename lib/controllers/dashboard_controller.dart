import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Observable variables
  final isLoading = false.obs;
  final isLoadingProfile = false.obs;
  final isLoadingStats = false.obs;
  final user = Rx<User?>(null);
  final errorMessage = ''.obs;
  final userName = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }
  
  void _loadUserFromStorage() {
    final storedUser = _storageService.getUser();
    if (storedUser != null) {
      user.value = storedUser;
    }
  }
  
  // Placeholder methods for future implementation
  Future<void> refreshData() async {
    debugPrint('🔍 DashboardController: refreshData not implemented');
  }
  
  Future<void> refreshDashboard() async {
    await refreshData();
  }
  
  void performTestLogin() async {
    debugPrint('🔍 DashboardController: performTestLogin not implemented');
  }
  
  void onSettingsTap() {
    debugPrint('🔍 DashboardController: onSettingsTap not implemented');
  }
  
  void onBidItemTap(UserBid bid) {
    debugPrint('🔍 DashboardController: onBidItemTap not implemented');
  }
  
  void onWatchlistItemTap(WatchlistItem item) {
    debugPrint('🔍 DashboardController: onWatchlistItemTap not implemented');
  }
  
  void removeFromWatchlist(String auctionId) {
    debugPrint('🔍 DashboardController: removeFromWatchlist not implemented');
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
  
  // Get storage service reference
  StorageService get storageService => _storageService;
}
