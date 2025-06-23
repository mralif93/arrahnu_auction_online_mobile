import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_padding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.put(HomeController());
  String selectedCategory = "All Items";

  final List<String> categories = [
    "All Items",
    "Rings",
    "Necklaces",
    "Bracelets",
    "Earrings",
    "Gold Coins",
  ];

  // Mock data for featured auctions
  final List<Map<String, String>> featuredAuctions = [
    {"title": "22K Gold Ring", "price": "RM 850", "time": "2h 15m"},
    {"title": "Gold Necklace", "price": "RM 1,200", "time": "4h 30m"},
    {"title": "Gold Bracelet", "price": "RM 950", "time": "1d 2h"},
  ];

  // Mock data for upcoming auctions
  final List<Map<String, String>> upcomingAuctions = [
    {
      "title": "Gold Earrings Set",
      "date": "Tomorrow 2:00 PM",
      "price": "RM 650"
    },
    {
      "title": "Vintage Gold Coin",
      "date": "Dec 25, 10:00 AM",
      "price": "RM 1,500"
    },
    {
      "title": "Diamond Ring",
      "date": "Dec 26, 3:00 PM",
      "price": "RM 2,200"
    },
  ];

  void _showMaterialFeedback(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => homeController.refreshData(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(screenWidth),
                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),
                _buildCategoryFilter(screenWidth),
                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),
                _buildFeaturedAuctions(screenWidth),
                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),
                _buildLiveAuctionCard(screenWidth),
                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),
                _buildUpcomingAuctions(screenWidth),
                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: AppTheme.getPadding(
        horizontal: ResponsivePadding.getTabletPadding(screenWidth),
        vertical: ResponsivePadding.getTabletPadding(screenWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Ar-Rahnu Auction",
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          SizedBox(height: ResponsivePadding.smallSpacing),
          Text(
            "Islamic Gold Auction",
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textWhite,
            ),
          ),
          SizedBox(height: ResponsivePadding.largeSpacing),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppTheme.largeRadius,
              boxShadow: [AppTheme.defaultShadow],
            ),
            child: TextField(
              decoration: AppTheme.inputDecoration.copyWith(
                hintText: "Search gold items...",
                prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                border: InputBorder.none,
                contentPadding: AppTheme.getPadding(horizontal: 20, vertical: 16),
              ),
              onTap: () => _showMaterialFeedback("Search functionality clicked!"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppTheme.getPadding(horizontal: ResponsivePadding.getTabletPadding(screenWidth)),
          child: Text(
            "Categories",
            style: AppTypography.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),
        SizedBox(
          height: ResponsivePadding.isTabletSize(screenWidth) ? 50 : 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: AppTheme.getPadding(horizontal: ResponsivePadding.getTabletPadding(screenWidth)),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;
              return Padding(
                padding: AppTheme.getPadding(horizontal: 4, vertical: 0),
                child: _buildCategoryChip(category, isSelected, screenWidth),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected, double screenWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        _showMaterialFeedback("$category selected!");
      },
      child: Container(
        padding: AppTheme.getPadding(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppTheme.mediumRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Text(
          category,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedAuctions(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppTheme.getPadding(horizontal: ResponsivePadding.getTabletPadding(screenWidth)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured Auctions",
                style: AppTypography.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: () => _showMaterialFeedback("View All clicked!"),
                child: Text(
                  "View All",
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTypography.semiBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),
        SizedBox(
          height: ResponsivePadding.isTabletSize(screenWidth) ? 220 : 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: AppTheme.getPadding(horizontal: ResponsivePadding.getTabletPadding(screenWidth)),
            itemCount: featuredAuctions.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: AppTheme.getPadding(horizontal: 8, vertical: 0),
                child: _buildAuctionCard(index, screenWidth),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuctionCard(int index, double screenWidth) {
    final currentItem = featuredAuctions[index];

    return GestureDetector(
      onTap: () => _showMaterialFeedback("${currentItem['title'] ?? 'Item'} auction clicked!"),
      child: Container(
        width: ResponsivePadding.isTabletSize(screenWidth) ? 200 : 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppTheme.mediumRadius,
          boxShadow: [AppTheme.defaultShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: ResponsivePadding.isTabletSize(screenWidth) ? 100 : 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.mediumRadius.topLeft.x),
                  topRight: Radius.circular(AppTheme.mediumRadius.topRight.x),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.diamond,
                  size: ResponsivePadding.isTabletSize(screenWidth) ? 40 : 30,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            Padding(
              padding: AppTheme.getPadding(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentItem['title'] ?? '',
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: AppTypography.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsivePadding.smallSpacing / 4),
                  Text(
                    "Starting ${currentItem['price'] ?? 'N/A'}",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.success,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsivePadding.smallSpacing / 4),
                  Text(
                    "Ends in ${currentItem['time'] ?? 'N/A'}",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveAuctionCard(double screenWidth) {
    return Padding(
      padding: AppTheme.getPadding(horizontal: ResponsivePadding.getTabletPadding(screenWidth)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.error],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppTheme.largeRadius,
        ),
        padding: AppTheme.getPadding(
          horizontal: ResponsivePadding.getTabletPadding(screenWidth),
          vertical: ResponsivePadding.getTabletPadding(screenWidth),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: AppTheme.getPadding(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: AppTheme.mediumRadius,
                  ),
                  child: Text(
                    "LIVE",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ),
                SizedBox(width: ResponsivePadding.smallSpacing),
                Text(
                  "Live Auction Now",
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: AppTypography.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: ResponsivePadding.smallSpacing),
            Text(
              "22K Gold Collection",
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textWhite,
                fontWeight: AppTypography.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: ResponsivePadding.smallSpacing),
            Text(
              "Ends in",
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textWhite,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "01:45:22",
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textWhite,
                fontWeight: AppTypography.bold,
                fontFamily: 'monospace',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: ResponsivePadding.smallSpacing),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showMaterialFeedback("Join Live Auction clicked!"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  padding: AppTheme.getPadding(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.smallRadius,
                  ),
                ),
                child: Text(
                  "Join Now",
                  style: AppTypography.buttonText.copyWith(
                    color: AppColors.primary,
                    fontSize: AppTypography.base,
                    fontWeight: AppTypography.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAuctions(double screenWidth) {
    return Padding(
      padding: AppTheme.getPadding(horizontal: ResponsivePadding.getTabletPadding(screenWidth)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming Auctions",
                style: AppTypography.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: () {
                  _showMaterialFeedback("Calendar clicked!");
                },
                child: Text(
                  "Calendar",
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTypography.semiBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),
          ...upcomingAuctions.map((auction) => Padding(
            padding: AppTheme.getPadding(vertical: 8, horizontal: 0),
            child: _buildUpcomingAuctionItem(
              auction["title"] ?? "Unknown Item",
              auction["date"] ?? "TBA",
              auction["price"] ?? "N/A",
              screenWidth,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildUpcomingAuctionItem(
    String title,
    String date,
    String startingPrice,
    double screenWidth,
  ) {
    return Container(
      padding: AppTheme.getPadding(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppTheme.mediumRadius,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsivePadding.isTabletSize(screenWidth) ? 60 : 50,
            height: ResponsivePadding.isTabletSize(screenWidth) ? 60 : 50,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              borderRadius: AppTheme.smallRadius,
            ),
            child: Icon(Icons.schedule, color: AppColors.primaryLight, size: ResponsivePadding.isTabletSize(screenWidth) ? 30 : 24),
          ),
          SizedBox(width: ResponsivePadding.smallSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Starting at",
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                startingPrice,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.success,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
