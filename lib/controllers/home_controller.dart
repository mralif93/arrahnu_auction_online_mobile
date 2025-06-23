import 'package:get/get.dart';
import 'dart:async';
import '../models/user.dart';

class HomeController extends GetxController {
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
    _initializeAuctionData();
    _startTimer();
  }
  
  void _initializeAuctionData() {
    // Initialize with empty data - will be populated from API
    auctionItems.value = [];
    auctionData.value = {};
    auctionsByBranch.value = {};
    
    // Set formatted dates
    formattedStartDate.value = '';
    formattedEndDate.value = '';
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
    timeRemaining.value = '00:00:00';
  }
  
  // Navigation methods
  void onViewAllTap() {
    // Navigate to view all auctions page
  }
  
  // Placeholder methods for future implementation
  Future<void> loadAuctions() async {
    // Load auctions from API
  }
  
  Future<void> loadCategories() async {
    // Load categories from API
  }
  
  Future<void> searchAuctions(String query) async {
    // Search auctions
  }
}
