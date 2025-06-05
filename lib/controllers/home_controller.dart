import 'dart:async';
import 'package:get/get.dart';

enum AuctionStatus { beforeStart, active, ended }

class HomeController extends GetxController {
  // Observable variables
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  // Auction session state
  var auctionStatus = AuctionStatus.beforeStart.obs;
  var timeRemaining = ''.obs;
  var timeRemainingLabel = 'Bidding Session Start In:'.obs;

  // Auction session dates (constants for now, will be from API later)
  final DateTime auctionStartDate = DateTime(
    2025,
    6,
    5,
    10,
    30,
  ); // 05/06/2025 10:30 a.m.
  final DateTime auctionEndDate = DateTime(
    2025,
    6,
    9,
    16,
    30,
  ); // 09/06/2025 04:30 p.m.

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

  // Sample auction items
  final auctionItems = [
    {
      'title': 'Gold Necklace',
      'currentBid': 'RM 2,500',
      'timeLeft': '2h 30m',
      'image': 'assets/gold_necklace.jpg',
      'category': 'Gold',
    },
    {
      'title': 'Diamond Ring',
      'currentBid': 'RM 5,200',
      'timeLeft': '1h 15m',
      'image': 'assets/diamond_ring.jpg',
      'category': 'Jewelry',
    },
    {
      'title': 'Silver Watch',
      'currentBid': 'RM 850',
      'timeLeft': '4h 45m',
      'image': 'assets/silver_watch.jpg',
      'category': 'Watches',
    },
    {
      'title': 'Gold Bracelet',
      'currentBid': 'RM 1,800',
      'timeLeft': '3h 20m',
      'image': 'assets/gold_bracelet.jpg',
      'category': 'Gold',
    },
  ];

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
  void onInit() {
    super.onInit();
    _updateAuctionStatus();
    // Start timer for real-time updates (disabled in tests)
    _startCountdownTimer();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  // Start the countdown timer
  void _startCountdownTimer() {
    _countdownTimer?.cancel(); // Cancel any existing timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

    if (now.isBefore(auctionStartDate)) {
      // Before auction starts
      auctionStatus.value = AuctionStatus.beforeStart;
      timeRemainingLabel.value = 'Bidding Session Start In:';
      timeRemaining.value = _formatDuration(auctionStartDate.difference(now));
    } else if (now.isAfter(auctionStartDate) && now.isBefore(auctionEndDate)) {
      // Auction is active
      auctionStatus.value = AuctionStatus.active;
      timeRemainingLabel.value = 'Bidding Session End In:';
      timeRemaining.value = _formatDuration(auctionEndDate.difference(now));
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
    return '${auctionStartDate.day.toString().padLeft(2, '0')}/${auctionStartDate.month.toString().padLeft(2, '0')}/${auctionStartDate.year} ${_formatTime(auctionStartDate)} (${_getDayName(auctionStartDate)})';
  }

  String get formattedEndDate {
    return '${auctionEndDate.day.toString().padLeft(2, '0')}/${auctionEndDate.month.toString().padLeft(2, '0')}/${auctionEndDate.year} ${_formatTime(auctionEndDate)} (${_getDayName(auctionEndDate)})';
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
}
