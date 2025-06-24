import 'dart:async';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/index.dart';

enum AuctionStatus { beforeStart, active, ended }

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable variables
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  // Refresh method for pull-to-refresh
  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      // In a real app, you would fetch fresh data from your API here
      // For now, we'll just simulate a refresh
      update();
    } finally {
      isLoading.value = false;
    }
  }

  // Auction session state
  var auctionStatus = AuctionStatus.beforeStart.obs;
  var timeRemaining = ''.obs;
  var timeRemainingLabel = 'Bidding Session Start In:'.obs;

  // Auction session dates
  var auctionStartDate = DateTime.now().obs;
  var auctionEndDate = DateTime.now().obs;

  // Auction items
  var dataAuctionItems = <AuctionItem>[].obs;
  var auctionItemsResponse = Rxn<AuctionItemsResponse>();

  Timer? _countdownTimer;

  // Categories list
  final categories = [
    'All',
    'Gold',
    'Silver',
    'Jewelry',
    'Electronics',
    'Watches',
  ];

  // Hierarchical auction data: Branch > Account > Collateral
  final auctionData = {
    'Kuala Lumpur Branch': {
      'ACC001': {
        'accountName': 'Ahmad bin Abdullah',
        'accountNumber': 'ACC001',
        'collaterals': [
          {
            'id': 'COL001',
            'title': '22K Gold Necklace Set',
            'currentBid': 'RM 2,500',
            'timeLeft': '2h 30m',
            'category': 'Gold Jewelry',
            'weight': '15.5g',
            'purity': '22K',
            'startingPrice': 'RM 2,000',
            'reservedPrice': 'RM 3,000',
            'totalPrice': 'RM 2,800',
            'goldType': 'Yellow Gold',
            'goldPrice': 'RM 285/g',
            'bidIncrement': 'RM 50',
            'description':
                'Beautiful traditional gold necklace with intricate design, crafted with 22K yellow gold featuring traditional Malaysian motifs.',
          },
          {
            'id': 'COL002',
            'title': '18K Gold Ring',
            'currentBid': 'RM 850',
            'timeLeft': '1h 45m',
            'category': 'Gold Jewelry',
            'weight': '4.2g',
            'purity': '18K',
            'startingPrice': 'RM 700',
            'reservedPrice': 'RM 1,200',
            'totalPrice': 'RM 950',
            'goldType': 'White Gold',
            'goldPrice': 'RM 265/g',
            'bidIncrement': 'RM 25',
            'description':
                'Elegant 18K white gold ring with diamond accent, perfect for special occasions.',
          },
        ],
      },
      'ACC002': {
        'accountName': 'Siti Nurhaliza',
        'accountNumber': 'ACC002',
        'collaterals': [
          {
            'id': 'COL003',
            'title': 'Diamond Wedding Ring',
            'currentBid': 'RM 5,200',
            'timeLeft': '3h 15m',
            'category': 'Diamond Jewelry',
            'weight': '3.8g',
            'purity': '18K Gold with 0.5ct Diamond',
            'startingPrice': 'RM 4,500',
            'reservedPrice': 'RM 6,000',
            'totalPrice': 'RM 5,500',
            'goldType': 'Rose Gold',
            'goldPrice': 'RM 270/g',
            'bidIncrement': 'RM 100',
            'description':
                'Stunning wedding ring with certified diamond, crafted in elegant rose gold setting.',
          },
        ],
      },
    },
    'Johor Bahru Branch': {
      'ACC003': {
        'accountName': 'Lim Wei Ming',
        'accountNumber': 'ACC003',
        'collaterals': [
          {
            'id': 'COL004',
            'title': '18K Gold Luxury Watch',
            'currentBid': 'RM 8,500',
            'timeLeft': '5h 20m',
            'category': 'Gold Watches',
            'weight': '85g',
            'purity': '18K',
            'startingPrice': 'RM 7,000',
            'reservedPrice': 'RM 9,500',
            'totalPrice': 'RM 9,200',
            'goldType': 'Yellow Gold',
            'goldPrice': 'RM 275/g',
            'bidIncrement': 'RM 200',
            'description':
                'Luxury 18K yellow gold watch with Swiss movement, excellent condition.',
          },
          {
            'id': 'COL005',
            'title': '24K Gold Bar',
            'currentBid': 'RM 8,800',
            'timeLeft': '4h 10m',
            'category': 'Gold Bullion',
            'weight': '50g',
            'purity': '24K',
            'startingPrice': 'RM 8,000',
            'reservedPrice': 'RM 10,000',
            'totalPrice': 'RM 9,500',
            'goldType': 'Pure Gold',
            'goldPrice': 'RM 290/g',
            'bidIncrement': 'RM 100',
            'description':
                'Certified 24K pure gold bar from reputable mint, investment grade quality.',
          },
        ],
      },
    },
    'Penang Branch': {
      'ACC004': {
        'accountName': 'Raj Kumar',
        'accountNumber': 'ACC004',
        'collaterals': [
          {
            'id': 'COL006',
            'title': 'Antique Gold Bracelet',
            'currentBid': 'RM 1,800',
            'timeLeft': '6h 30m',
            'category': 'Antique Jewelry',
            'weight': '12.3g',
            'purity': '22K',
            'startingPrice': 'RM 1,500',
            'reservedPrice': 'RM 2,200',
            'totalPrice': 'RM 2,000',
            'goldType': 'Antique Gold',
            'goldPrice': 'RM 280/g',
            'bidIncrement': 'RM 50',
            'description':
                'Vintage 22K gold bracelet with traditional craftsmanship, heritage piece from early 1900s.',
          },
        ],
      },
    },
  };

  // Flattened auction items for easy display
  List<Map<String, dynamic>> get auctionItems {
    List<Map<String, dynamic>> items = [];

    auctionData.forEach((branchName, accounts) {
      accounts.forEach((accountNumber, accountData) {
        final collaterals =
            accountData['collaterals'] as List<Map<String, dynamic>>?;
        if (collaterals != null) {
          for (var collateral in collaterals) {
            items.add({
              ...collateral,
              'branchName': branchName,
              'accountName': accountData['accountName'],
              'accountNumber': accountNumber,
            });
          }
        }
      });
    });

    return items;
  }

  // Get auction data organized by branch for hierarchical display
  Map<String, List<Map<String, dynamic>>> get auctionsByBranch {
    Map<String, List<Map<String, dynamic>>> branchData = {};

    auctionData.forEach((branchName, accounts) {
      branchData[branchName] = [];
      accounts.forEach((accountNumber, accountData) {
        final collaterals =
            accountData['collaterals'] as List<Map<String, dynamic>>?;
        if (collaterals != null) {
          for (var collateral in collaterals) {
            branchData[branchName]!.add({
              ...collateral,
              'accountName': accountData['accountName'],
              'accountNumber': accountNumber,
            });
          }
        }
      });
    });

    return branchData;
  }

  // Get auction data organized by account for detailed view
  Map<String, Map<String, dynamic>> get auctionsByAccount {
    Map<String, Map<String, dynamic>> accountData = {};

    auctionData.forEach((branchName, accounts) {
      accounts.forEach((accountNumber, accountInfo) {
        accountData[accountNumber] = {
          'branchName': branchName,
          'accountName': accountInfo['accountName'],
          'accountNumber': accountNumber,
          'collaterals': accountInfo['collaterals'],
        };
      });
    });

    return accountData;
  }

  // Methods
  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void onSearchTap() {
    // Handle search functionality
    // TODO: Implement search functionality
  }

  void onViewAllTap() {
    // Navigate to view all auctions
    // TODO: Implement view all navigation
  }

  void onAuctionItemTap(Map<String, dynamic> item) {
    // Navigate to auction item details
    // TODO: Implement auction item navigation
  }

  void onCalendarTap() {
    // Show calendar view
    // TODO: Implement calendar functionality
  }

  void onJoinLiveAuctionTap() {
    // Join live auction
    // TODO: Implement live auction functionality
  }

  @override
  void onInit() async {
    super.onInit();

    // fetch start and end date from api service
    await fetchApiService();
    await fetchAuctionItems();

    // update auction status
    _updateAuctionStatus();

    // Start timer for real-time updates (disabled in tests)
    _startCountdownTimer();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchApiService() async {
    try {
      final auction = await _apiService.getActiveAuctions();
      if (auction['success'] == true && 
          auction['data'] != null && 
          auction['data'] is List && 
          auction['data'].isNotEmpty) {
        
        auctionStartDate.value = DateTime.parse(auction['data'][0]['start_datetime']).toLocal();
        auctionEndDate.value = DateTime.parse(auction['data'][0]['end_datetime']).toLocal();
      }
    } catch (e) {
      print('Error fetching auction dates: $e');
    }
  }

  Future<void> fetchAuctionItems() async {
    try {
      final response = await _apiService.getAuctionItems();
      final auctionResponse = AuctionItemsResponse.fromJson(response);
      
      // Update the response object
      auctionItemsResponse.value = auctionResponse;
      
      // Update the flat list of auction items
      dataAuctionItems.value = auctionResponse.allCollaterals;
      
      print('Fetched ${dataAuctionItems.length} auction items from ${auctionResponse.branchData.length} branches');
    } catch (e) {
      print('Error fetching auction items: $e');
    }
  }

  // Start the countdown timer
  void _startCountdownTimer() {
    _countdownTimer?.cancel(); // Cancel any existing timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      try {
        _updateAuctionStatus();
      } catch (e) {
        print('Error updating auction status: $e');
        timer.cancel();
      }
    });
  }

  // Update auction status based on current time
  void _updateAuctionStatus() {
    final now = DateTime.now();

    if (now.isBefore(auctionStartDate.value)) {
      // Before auction starts
      auctionStatus.value = AuctionStatus.beforeStart;
      timeRemainingLabel.value = 'Bidding Session Start In:';
      timeRemaining.value = _formatDuration(auctionStartDate.value.difference(now));
    } else if (now.isAfter(auctionStartDate.value) && now.isBefore(auctionEndDate.value)) {
      // Auction is active
      auctionStatus.value = AuctionStatus.active;
      timeRemainingLabel.value = 'Bidding Session End In:';
      timeRemaining.value = _formatDuration(auctionEndDate.value.difference(now));
    } else {
      // Auction has ended
      auctionStatus.value = AuctionStatus.ended;
      timeRemainingLabel.value = 'Auction Ended';
      timeRemaining.value = 'Session Closed';
      _countdownTimer?.cancel();
    }

    // Force update to ensure reactivity
    update();
  }

  // Format duration to user-friendly string
  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '0d 0h 0m 0s';

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  // Demo methods for testing (will be removed in production)
  void simulateAuctionStart() {
    // For demo: set start date to 1 minute ago, end date to 1 hour from now
    final now = DateTime.now();
    final newStart = now.subtract(const Duration(minutes: 1));
    final newEnd = now.add(const Duration(hours: 1));

    // Update the dates (in real app, this would come from API)
    // For now, we'll just force the status
    auctionStatus.value = AuctionStatus.active;
    timeRemainingLabel.value = 'Bidding Session End In:';
    timeRemaining.value = _formatDuration(newEnd.difference(now));
  }

  void simulateAuctionEnd() {
    auctionStatus.value = AuctionStatus.ended;
    timeRemainingLabel.value = 'Auction Ended';
    timeRemaining.value = 'Session Closed';
  }

  void resetToBeforeStart() {
    // Reset to original dates
    _updateAuctionStatus();
  }

  // Get formatted auction dates for display
  String get formattedStartDate {
    return '${auctionStartDate.value.day.toString().padLeft(2, '0')}/${auctionStartDate.value.month.toString().padLeft(2, '0')}/${auctionStartDate.value.year} ${_formatTime(auctionStartDate.value)} (${_getDayName(auctionStartDate.value)})';
  }

  String get formattedEndDate {
    return '${auctionEndDate.value.day.toString().padLeft(2, '0')}/${auctionEndDate.value.month.toString().padLeft(2, '0')}/${auctionEndDate.value.year} ${_formatTime(auctionEndDate.value)} (${_getDayName(auctionEndDate.value)})';
  }

  String get currentDate {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'p.m.' : 'a.m.';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _getDayName(DateTime dateTime) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dateTime.weekday - 1];
  }

  // Get filtered auction items based on category and search query
  List<AuctionItem> get filteredAuctionItems {
    return dataAuctionItems.where((item) {
      final matchesCategory = selectedCategory.value == 'All' || 
                            item.category == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty ||
                          item.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                          item.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Get auction items for a specific branch
  List<AuctionItem> getAuctionItemsByBranch(String branchName) {
    return auctionItemsResponse.value?.getCollateralsByBranch(branchName) ?? [];
  }
}
