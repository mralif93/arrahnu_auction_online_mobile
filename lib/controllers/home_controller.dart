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

  // Categories list
  final categories = [
    'All',
    'Gold',
    'Silver',
    'Jewelry',
    'Electronics',
    'Watches',
  ];

  // Auction items from API
  var dataAuctionItems = <AuctionItem>[].obs;
  var auctionItemsResponse = Rxn<AuctionItemsResponse>();

  Timer? _countdownTimer;

  // Get auction data organized by branch for hierarchical display
  Map<String, BranchAuctionData> get auctionsByBranch {
    if (auctionItemsResponse.value == null) return {};

    Map<String, BranchAuctionData> branchData = {};
    for (var branch in auctionItemsResponse.value!.branchData) {
      branchData[branch.branchName] = branch;
    }
    return branchData;
  }

  // Get all collaterals for a specific branch
  List<AuctionItem> getCollateralsForBranch(String branchName) {
    return auctionsByBranch[branchName]?.collaterals ?? [];
  }

  // Get total number of items across all branches
  int get totalItems {
    if (auctionItemsResponse.value == null) return 0;
    return auctionItemsResponse.value!.branchData
        .map((branch) => branch.totalCollaterals)
        .fold<int>(0, (sum, count) => sum + count);
  }

  // Get total number of accounts across all branches
  int get totalAccounts {
    if (auctionItemsResponse.value == null) return 0;
    return auctionItemsResponse.value!.branchData
        .map((branch) => branch.totalAccounts)
        .fold<int>(0, (sum, count) => sum + count);
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

  void onAuctionItemTap(AuctionItem item) {
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
    if (auctionItemsResponse.value == null) return [];
    
    final allItems = auctionItemsResponse.value!.allCollaterals;

    return allItems.where((item) {
      final matchesCategory = selectedCategory.value == 'All' || 
                          item.category == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty ||
                          item.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                          item.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
