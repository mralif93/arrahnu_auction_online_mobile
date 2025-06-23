import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../services/storage_service.dart';
import '../models/user.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Observable variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  // Auction status and data
  final auctionStatus = AuctionStatus.beforeStart.obs;
  final selectedCategory = 'All'.obs;
  final auctionItems = <Map<String, dynamic>>[].obs;
  
  // Date and time related
  final _currentDate = DateTime.now().obs;
  final formattedStartDate = ''.obs;
  final formattedEndDate = ''.obs;
  final timeRemainingLabel = 'Loading...'.obs;
  final timeRemaining = '00:00:00'.obs;
  
  // Auction data by branch
  final auctionData = <String, Map<String, dynamic>>{}.obs;
  final auctionsByBranch = <String, List<Map<String, dynamic>>>{}.obs;
  
  // Getter methods for non-reactive access
  String get currentDate => _formatDate(_currentDate.value);
  String get startDate => formattedStartDate.value;
  String get endDate => formattedEndDate.value;
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  @override
  void onInit() {
    super.onInit();
    debugPrint('🔍 HomeController initialized');
    _initializeAuctionData();
    _startTimer();
  }
  
  void _initializeAuctionData() {
    // Initialize with sample data
    auctionItems.value = [
      {
        'title': 'Gold Ring',
        'category': 'Jewelry',
        'branchName': 'Kuala Lumpur Branch',
        'accountNumber': 'ACC001',
        'currentBid': 'RM 1,500',
        'timeLeft': '2h 30m',
        'purity': '916',
      },
      {
        'title': 'Gold Chain',
        'category': 'Jewelry',
        'branchName': 'Penang Branch',
        'accountNumber': 'ACC002',
        'currentBid': 'RM 2,200',
        'timeLeft': '1h 45m',
        'purity': '999',
      },
    ];
    
    // Initialize auction data by branch
    auctionData.value = {
      'Kuala Lumpur Branch': {
        'Gold Ring': {'currentBid': 'RM 1,500', 'timeLeft': '2h 30m'},
        'Gold Chain': {'currentBid': 'RM 2,200', 'timeLeft': '1h 45m'},
      },
      'Penang Branch': {
        'Gold Bracelet': {'currentBid': 'RM 1,800', 'timeLeft': '3h 15m'},
      },
    };
    
    auctionsByBranch.value = {
      'Kuala Lumpur Branch': [
        {'title': 'Gold Ring', 'currentBid': 'RM 1,500', 'timeLeft': '2h 30m'},
        {'title': 'Gold Chain', 'currentBid': 'RM 2,200', 'timeLeft': '1h 45m'},
      ],
      'Penang Branch': [
        {'title': 'Gold Bracelet', 'currentBid': 'RM 1,800', 'timeLeft': '3h 15m'},
      ],
    };
    
    // Set formatted dates
    formattedStartDate.value = '2024-01-15';
    formattedEndDate.value = '2024-01-20';
  }
  
  void _startTimer() {
    // Update current date every second
    ever(_currentDate, (DateTime date) {
      _updateTimeRemaining();
    });
    
    // Start timer to update current date
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentDate.value = DateTime.now();
    });
  }
  
  void _updateTimeRemaining() {
    // Calculate time remaining logic here
    timeRemainingLabel.value = 'Time Remaining';
    timeRemaining.value = '02:30:15';
  }
  
  // Navigation methods
  void onViewAllTap() {
    debugPrint('🔍 HomeController: onViewAllTap called');
    // Navigate to view all auctions page
  }
  
  // Placeholder methods for future implementation
  Future<void> loadAuctions() async {
    debugPrint('🔍 HomeController: loadAuctions not implemented');
  }
  
  Future<void> loadCategories() async {
    debugPrint('🔍 HomeController: loadCategories not implemented');
  }
  
  Future<void> searchAuctions(String query) async {
    debugPrint('🔍 HomeController: searchAuctions not implemented');
  }
}
