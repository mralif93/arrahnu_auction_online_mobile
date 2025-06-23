import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';

enum AuctionStatus {
  beforeStart,
  ongoing,
  completed,
}

class HomeController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  // Auction status and data
  final auctionStatus = AuctionStatus.beforeStart.obs;
  final selectedCategory = 'All'.obs;
  final auctionItems = <Map<String, dynamic>>[].obs;
  final auctionData = <String, Map<String, dynamic>>{}.obs;
  
  // Date and time related
  final _currentDate = DateTime.now().obs;
  final formattedStartDate = ''.obs;
  final formattedEndDate = ''.obs;
  final timeRemainingLabel = 'Loading...'.obs;
  final timeRemaining = '00:00:00'.obs;
  
  // Categories
  final categories = <String>[
    'All',
    'Gold',
    'Silver',
    'Jewelry',
    'Watches',
  ];
  
  Timer? _timer;
  
  // Initial auction items data
  final _initialAuctionData = [
    {
      'id': 'AUCT001',
      'title': 'Gold Necklace 916',
      'description': 'Beautiful 22K gold necklace with intricate design',
      'category': 'Gold',
      'currentBid': '5500.00',
      'startingBid': '5000.00',
      'imageUrl': 'assets/images/poster/001.png',
      'endTime': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      'status': 'ongoing',
      'branchName': 'Kuala Lumpur',
      'weight': '25g',
      'purity': '916',
      'bidCount': 5,
    },
    {
      'id': 'AUCT002',
      'title': 'Silver Bracelet 925',
      'description': 'Elegant sterling silver bracelet',
      'category': 'Silver',
      'currentBid': '800.00',
      'startingBid': '500.00',
      'imageUrl': 'assets/images/poster/002.png',
      'endTime': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      'status': 'ongoing',
      'branchName': 'Penang',
      'weight': '30g',
      'purity': '925',
      'bidCount': 3,
    },
    {
      'id': 'AUCT003',
      'title': 'Gold Ring 750',
      'description': 'Elegant 18K gold ring with diamond setting',
      'category': 'Gold',
      'currentBid': '3200.00',
      'startingBid': '3000.00',
      'imageUrl': 'assets/images/poster/001.png', // Reusing first poster as we only have 2
      'endTime': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'status': 'upcoming',
      'branchName': 'Johor Bahru',
      'weight': '10g',
      'purity': '750',
      'bidCount': 0,
    },
  ];
  
  // Branch accounts data
  final branchAccounts = <String, Map<String, dynamic>>{
    'Kuala Lumpur': {
      'ACC001': {
        'balance': '5000.00',
        'status': 'active',
        'lastTransaction': '2024-03-15',
      },
      'ACC002': {
        'balance': '3500.00',
        'status': 'inactive',
        'lastTransaction': '2024-03-10',
      },
    },
    'Penang': {
      'ACC003': {
        'balance': '7500.00',
        'status': 'active',
        'lastTransaction': '2024-03-14',
      },
    },
    'Johor Bahru': {
      'ACC004': {
        'balance': '4200.00',
        'status': 'pending',
        'lastTransaction': '2024-03-13',
      },
      'ACC005': {
        'balance': '6300.00',
        'status': 'active',
        'lastTransaction': '2024-03-12',
      },
    },
  }.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadAuctionItems();
  }
  
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
  
  void _initializeAuctionData() {
    // Dummy branch data
    auctionData.value = {
      'Kuala Lumpur Main Branch': {
        'ACC001': {
          'accountName': 'Ahmad bin Abdullah',
          'collaterals': [
            {
              'id': 'COL001',
              'type': 'Gold Necklace',
              'weight': '25g',
              'purity': '916',
              'startingBid': 5000.0,
              'currentBid': 5500.0,
              'status': 'ongoing',
            },
            {
              'id': 'COL002',
              'type': 'Gold Ring',
              'weight': '10g',
              'purity': '916',
              'startingBid': 2000.0,
              'currentBid': 2200.0,
              'status': 'upcoming',
            },
          ],
        },
        'ACC002': {
          'accountName': 'Siti binti Rahman',
          'collaterals': [
            {
              'id': 'COL003',
              'type': 'Gold Bracelet',
              'weight': '30g',
              'purity': '916',
              'startingBid': 6000.0,
              'currentBid': 6500.0,
              'status': 'ongoing',
            },
          ],
        },
      },
      'Penang Branch': {
        'ACC003': {
          'accountName': 'Tan Wei Ming',
          'collaterals': [
            {
              'id': 'COL004',
              'type': 'Gold Chain',
              'weight': '40g',
              'purity': '916',
              'startingBid': 8000.0,
              'currentBid': 8200.0,
              'status': 'upcoming',
            },
          ],
        },
      },
    };
    
    // Dummy auction items
    auctionItems.value = [
      {
        'id': 'ITEM001',
        'title': 'Gold Necklace 916',
        'description': 'Beautiful gold necklace with intricate design',
        'weight': '25g',
        'purity': '916',
        'startingBid': 5000.0,
        'currentBid': 5500.0,
        'bidCount': 5,
        'status': 'ongoing',
        'endTime': DateTime.now().add(const Duration(hours: 24)),
        'images': ['assets/images/items/necklace.jpg'],
        'branch': 'Kuala Lumpur Main Branch',
        'accountNumber': 'ACC001',
      },
      {
        'id': 'ITEM002',
        'title': 'Gold Ring 750',
        'description': 'Elegant gold ring with diamond setting',
        'weight': '10g',
        'purity': '750',
        'startingBid': 3000.0,
        'currentBid': 3200.0,
        'bidCount': 3,
        'status': 'upcoming',
        'endTime': DateTime.now().add(const Duration(hours: 48)),
        'images': ['assets/images/items/ring.jpg'],
        'branch': 'Penang Branch',
        'accountNumber': 'ACC003',
      },
    ];
    
    _updateAuctionStatus();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeRemaining();
    });
  }
  
  void _updateTimeRemaining() {
    if (auctionItems.isEmpty) return;
    
    final now = DateTime.now();
    final endTime = auctionItems[0]['endTime'] as DateTime;
    final difference = endTime.difference(now);
    
    if (difference.isNegative) {
      timeRemaining.value = '00:00:00';
      timeRemainingLabel.value = 'Auction Ended';
      _updateAuctionStatus();
    } else {
      final hours = difference.inHours.toString().padLeft(2, '0');
      final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
      timeRemaining.value = '$hours:$minutes:$seconds';
      timeRemainingLabel.value = 'Time Remaining';
    }
  }
  
  void _updateAuctionStatus() {
    if (auctionItems.isEmpty) {
      auctionStatus.value = AuctionStatus.beforeStart;
      return;
    }
    
    final now = DateTime.now();
    final endTime = auctionItems[0]['endTime'] as DateTime;
    
    if (now.isAfter(endTime)) {
      auctionStatus.value = AuctionStatus.completed;
    } else {
      auctionStatus.value = AuctionStatus.ongoing;
    }
  }
  
  void onCategoryChanged(String category) {
    selectedCategory.value = category;
    loadAuctionItems();
  }
  
  Future<void> loadAuctionItems() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Start with initial data
      final List<Map<String, dynamic>> items = List.from(_initialAuctionData);
      
      // Filter items based on category if needed
      if (selectedCategory.value != 'All') {
        items.removeWhere((item) => item['category'] != selectedCategory.value);
      }
      
      // Update the observable list
      auctionItems.value = items;
      
    } catch (e) {
      errorMessage.value = 'Failed to load auction items';
      print('Error loading auction items: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshHome() async {
    await loadAuctionItems();
  }
  
  String formatCurrency(String amount) {
    return 'RM $amount';
  }
  
  String formatTimeLeft(String endTimeStr) {
    try {
      final endTime = DateTime.parse(endTimeStr);
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
  
  String getStatusText(String status) {
    return status.toUpperCase();
  }
  
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return Colors.green;
      case 'upcoming':
        return Colors.blue;
      case 'ended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
