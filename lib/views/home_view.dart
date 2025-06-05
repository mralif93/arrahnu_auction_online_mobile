import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(child: _buildResponsiveLayout(context)),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = _isTabletSize(screenWidth);

    if (isTablet) {
      return _buildTabletLayout(context, screenWidth);
    } else {
      return _buildMobileLayout();
    }
  }

  bool _isTabletSize(double screenWidth) {
    // Tablet sizes: 10" (~768px), 11" (~834px), 12" (~1024px), 13" (~1112px), 14" (~1194px)
    return screenWidth >= 768;
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Logo Section
          _buildLogo(),

          const SizedBox(height: 20),

          // Conditional Content Based on Auction Status
          Obx(() {
            final status = controller.auctionStatus.value;
            if (status == AuctionStatus.beforeStart ||
                status == AuctionStatus.ended) {
              // Before start or ended - only show session info
              return Column(
                children: [
                  _buildBiddingSessionInfo(),
                  const SizedBox(height: 20),
                  // Show test buttons for demo
                  _buildTestControls(),
                  const SizedBox(height: 20),
                ],
              );
            } else if (status == AuctionStatus.active) {
              // During auction - show all components
              return Column(
                children: [
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 20),

                  // Categories Section
                  _buildCategoriesSection(),
                  const SizedBox(height: 20),

                  // Featured Auctions Section
                  _buildFeaturedAuctionsSection(),
                  const SizedBox(height: 20),

                  // Live Auction Banner
                  _buildLiveAuctionBanner(),
                  const SizedBox(height: 20),

                  // Show test buttons for demo
                  _buildTestControls(),
                  const SizedBox(height: 16),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, double screenWidth) {
    final tabletPadding = _getTabletPadding(screenWidth);
    final isLargeTablet = screenWidth >= 1024; // 12"+ tablets

    return Padding(
      padding: EdgeInsets.all(tabletPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Logo Section - Tablet optimized
          _buildTabletLogo(screenWidth),

          const SizedBox(height: 24),

          // Conditional Content Based on Auction Status
          Obx(() {
            final status = controller.auctionStatus.value;
            if (status == AuctionStatus.beforeStart ||
                status == AuctionStatus.ended) {
              // Before start or ended - tablet layout
              return Column(
                children: [
                  if (isLargeTablet)
                    _buildTabletTwoColumnLayout(
                      left: _buildBiddingSessionInfo(),
                      right: _buildTestControls(),
                    )
                  else
                    Column(
                      children: [
                        _buildBiddingSessionInfo(),
                        const SizedBox(height: 24),
                        _buildTestControls(),
                      ],
                    ),
                  const SizedBox(height: 24),
                ],
              );
            } else if (status == AuctionStatus.active) {
              // During auction - tablet layout
              return Column(
                children: [
                  // Search Bar - Tablet optimized
                  _buildTabletSearchBar(screenWidth),
                  const SizedBox(height: 24),

                  // Categories Section - Tablet optimized
                  _buildTabletCategoriesSection(screenWidth),
                  const SizedBox(height: 24),

                  // Featured Auctions Section - Tablet grid
                  _buildTabletFeaturedAuctionsSection(screenWidth),
                  const SizedBox(height: 24),

                  // Live Auction Banner - Tablet optimized
                  _buildTabletLiveAuctionBanner(screenWidth),
                  const SizedBox(height: 24),

                  // Test controls
                  _buildTestControls(),
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  double _getTabletPadding(double screenWidth) {
    if (screenWidth >= 1194) return 32.0; // 14" tablets
    if (screenWidth >= 1112) return 28.0; // 13" tablets
    if (screenWidth >= 1024) return 24.0; // 12" tablets
    if (screenWidth >= 834) return 20.0; // 11" tablets
    return 16.0; // 10" tablets
  }

  Widget _buildTabletLogo(double screenWidth) {
    final logoHeight = _getTabletLogoHeight(screenWidth);
    final containerPadding = _getTabletLogoPadding(screenWidth);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth >= 1024 ? 24 : 16,
        vertical: screenWidth >= 1024 ? 12 : 8,
      ),
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth >= 1024 ? 20 : 16),
        border: Border.all(
          color: const Color(0xFFFE8000).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.08),
            blurRadius: screenWidth >= 1024 ? 16 : 12,
            offset: Offset(0, screenWidth >= 1024 ? 6 : 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: screenWidth >= 1024 ? 12 : 8,
            offset: Offset(0, screenWidth >= 1024 ? 3 : 2),
          ),
        ],
      ),
      child: SizedBox(
        height: logoHeight,
        child: Image.asset(
          'assets/images/logo/001.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.account_balance,
              size: logoHeight * 0.75,
              color: const Color(0xFFFE8000),
            );
          },
        ),
      ),
    );
  }

  double _getTabletLogoHeight(double screenWidth) {
    if (screenWidth >= 1194) return 120.0; // 14" tablets
    if (screenWidth >= 1112) return 110.0; // 13" tablets
    if (screenWidth >= 1024) return 100.0; // 12" tablets
    if (screenWidth >= 834) return 90.0; // 11" tablets
    return 80.0; // 10" tablets
  }

  double _getTabletLogoPadding(double screenWidth) {
    if (screenWidth >= 1194) return 28.0; // 14" tablets
    if (screenWidth >= 1112) return 26.0; // 13" tablets
    if (screenWidth >= 1024) return 24.0; // 12" tablets
    if (screenWidth >= 834) return 22.0; // 11" tablets
    return 20.0; // 10" tablets
  }

  Widget _buildTabletTwoColumnLayout({
    required Widget left,
    required Widget right,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: left),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: right),
      ],
    );
  }

  Widget _buildTabletSearchBar(double screenWidth) {
    final searchHeight = screenWidth >= 1024 ? 60.0 : 56.0;
    final borderRadius = screenWidth >= 1024 ? 30.0 : 28.0;
    final iconSize = screenWidth >= 1024 ? 26.0 : 24.0;
    final fontSize = screenWidth >= 1024 ? 17.0 : 16.0;

    return Container(
      height: searchHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFFFE8000).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.1),
            blurRadius: screenWidth >= 1024 ? 12 : 8,
            offset: Offset(0, screenWidth >= 1024 ? 3 : 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: screenWidth >= 1024 ? 24 : 20),
          Icon(Icons.search, color: const Color(0xFFFE8000), size: iconSize),
          SizedBox(width: screenWidth >= 1024 ? 16 : 14),
          Expanded(
            child: TextField(
              onChanged: controller.updateSearchQuery,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              decoration: InputDecoration(
                hintText: "Search auctions...",
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenWidth >= 1024 ? 18 : 16,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: screenWidth >= 1024 ? 8 : 6),
            padding: EdgeInsets.all(screenWidth >= 1024 ? 12 : 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFE8000),
              borderRadius: BorderRadius.circular(
                screenWidth >= 1024 ? 24 : 22,
              ),
            ),
            child: Icon(
              Icons.tune,
              color: Colors.white,
              size: screenWidth >= 1024 ? 22 : 20,
            ),
          ),
          SizedBox(width: screenWidth >= 1024 ? 8 : 6),
        ],
      ),
    );
  }

  Widget _buildTabletCategoriesSection(double screenWidth) {
    final titleFontSize = screenWidth >= 1024 ? 24.0 : 22.0;
    final viewAllFontSize = screenWidth >= 1024 ? 16.0 : 15.0;
    final chipHeight = screenWidth >= 1024 ? 48.0 : 44.0;
    final chipSpacing = screenWidth >= 1024 ? 16.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            GestureDetector(
              onTap: controller.onViewAllTap,
              child: Text(
                "View All",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: viewAllFontSize,
                  color: const Color(0xFFFE8000),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth >= 1024 ? 16 : 14),
        SizedBox(
          height: chipHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Padding(
                padding: EdgeInsets.only(right: chipSpacing),
                child: Obx(() {
                  final isSelected =
                      controller.selectedCategory.value == category;
                  return _buildTabletCategoryChip(
                    category,
                    isSelected,
                    screenWidth,
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabletCategoryChip(
    String category,
    bool isSelected,
    double screenWidth,
  ) {
    final fontSize = screenWidth >= 1024 ? 16.0 : 15.0;
    final horizontalPadding = screenWidth >= 1024 ? 20.0 : 18.0;
    final verticalPadding = screenWidth >= 1024 ? 12.0 : 10.0;

    return GestureDetector(
      onTap: () => controller.selectCategory(category),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFE8000) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(screenWidth >= 1024 ? 24 : 22),
          border: Border.all(
            color: isSelected ? const Color(0xFFFE8000) : Colors.grey.shade400,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFE8000).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: fontSize,
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTabletFeaturedAuctionsSection(double screenWidth) {
    final titleFontSize = screenWidth >= 1024 ? 24.0 : 22.0;
    final viewAllFontSize = screenWidth >= 1024 ? 16.0 : 15.0;
    final crossAxisCount = _getTabletGridCrossAxisCount(screenWidth);
    final childAspectRatio = _getTabletGridAspectRatio(screenWidth);
    final crossAxisSpacing = screenWidth >= 1024 ? 16.0 : 14.0;
    final mainAxisSpacing = screenWidth >= 1024 ? 16.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured Auctions",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            GestureDetector(
              onTap: controller.onViewAllTap,
              child: Text(
                "View All",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: viewAllFontSize,
                  color: const Color(0xFFFE8000),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth >= 1024 ? 16 : 14),
        Obx(() {
          final selectedCategory = controller.selectedCategory.value;
          final items = selectedCategory == 'All'
              ? controller.auctionItems
              : controller.auctionItems
                    .where((item) => item['category'] == selectedCategory)
                    .toList();
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildTabletAuctionCard(item, screenWidth);
            },
          );
        }),
      ],
    );
  }

  int _getTabletGridCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1194) return 4; // 14" tablets - 4 columns
    if (screenWidth >= 1112) return 4; // 13" tablets - 4 columns
    if (screenWidth >= 1024) return 3; // 12" tablets - 3 columns
    if (screenWidth >= 834) return 3; // 11" tablets - 3 columns
    return 2; // 10" tablets - 2 columns
  }

  double _getTabletGridAspectRatio(double screenWidth) {
    if (screenWidth >= 1194) return 0.9; // 14" tablets
    if (screenWidth >= 1112) return 0.88; // 13" tablets
    if (screenWidth >= 1024) return 0.85; // 12" tablets
    if (screenWidth >= 834) return 0.82; // 11" tablets
    return 0.8; // 10" tablets
  }

  Widget _buildTabletAuctionCard(
    Map<String, dynamic> item,
    double screenWidth,
  ) {
    final cardPadding = screenWidth >= 1024 ? 16.0 : 14.0;
    final borderRadius = screenWidth >= 1024 ? 16.0 : 14.0;
    final titleFontSize = screenWidth >= 1024 ? 16.0 : 15.0;
    final priceFontSize = screenWidth >= 1024 ? 18.0 : 17.0;
    final detailFontSize = screenWidth >= 1024 ? 13.0 : 12.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFFFE8000).withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.08),
            blurRadius: screenWidth >= 1024 ? 12 : 8,
            offset: Offset(0, screenWidth >= 1024 ? 4 : 3),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: screenWidth >= 1024 ? 8 : 6,
            offset: Offset(0, screenWidth >= 1024 ? 2 : 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Container(
            height: screenWidth >= 1024 ? 140 : 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: screenWidth >= 1024 ? 48 : 40,
                color: Colors.grey.shade400,
              ),
            ),
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? 'Auction Item',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth >= 1024 ? 8 : 6),
                  Text(
                    item['price'] ?? 'RM 0',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: priceFontSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFE8000),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    item['category'] ?? 'Category',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: detailFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLiveAuctionBanner(double screenWidth) {
    final bannerPadding = screenWidth >= 1024 ? 28.0 : 24.0;
    final borderRadius = screenWidth >= 1024 ? 20.0 : 18.0;
    final titleFontSize = screenWidth >= 1024 ? 28.0 : 26.0;
    final subtitleFontSize = screenWidth >= 1024 ? 18.0 : 17.0;
    final buttonFontSize = screenWidth >= 1024 ? 18.0 : 17.0;
    final iconSize = screenWidth >= 1024 ? 32.0 : 28.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(bannerPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFE8000),
            const Color(0xFFFE8000).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.4),
            blurRadius: screenWidth >= 1024 ? 20 : 16,
            offset: Offset(0, screenWidth >= 1024 ? 8 : 6),
          ),
        ],
      ),
      child: screenWidth >= 1024
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.live_tv,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "LIVE AUCTION",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Join the excitement! Bid on premium gold items now.",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: controller.onJoinLiveAuctionTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFE8000),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      "Join Now",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.live_tv,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "LIVE AUCTION",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Join the excitement! Bid on premium gold items now.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.onJoinLiveAuctionTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFE8000),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      "Join Now",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFE8000).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        height: 80,
        child: Image.asset(
          'assets/images/logo/001.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.account_balance,
              size: 60,
              color: const Color(0xFFFE8000),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFFE8000).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          Icon(Icons.search, color: const Color(0xFFFE8000), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: controller.updateSearchQuery,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              decoration: InputDecoration(
                hintText: "Search auctions...",
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFE8000),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.tune, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            GestureDetector(
              onTap: controller.onViewAllTap,
              child: Text(
                "View All",
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Color(0xFFFE8000),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Obx(() {
                  final isSelected =
                      controller.selectedCategory.value == category;
                  return _buildCategoryChip(category, isSelected);
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFE8000) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFE8000) : Colors.grey.shade400,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildBiddingSessionInfo() {
    return Obx(() {
      final isEnded = controller.auctionStatus.value == AuctionStatus.ended;

      if (isEnded) {
        return _buildAuctionEndedCard();
      } else {
        return _buildUpcomingAuctionCard();
      }
    });
  }

  Widget _buildUpcomingAuctionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFE8000).withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFE8000).withValues(alpha: 0.08),
                  const Color(0xFFFE8000).withValues(alpha: 0.04),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Compact logo container
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFFE8000).withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/logo/001.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_balance,
                          color: const Color(0xFFFE8000),
                          size: 20,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Compact title and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Compact status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFE8000),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFE8000,
                              ).withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'Upcoming Auction',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Compact title
                      Text(
                        "Sistem e-Lelong",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Ar-Rahnu Online Auction",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFE8000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Compact content section
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Compact current date
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.today,
                          size: 16,
                          color: const Color(0xFFFE8000),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Date",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            controller.currentDate,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Compact auction schedule section
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.schedule,
                        size: 14,
                        color: const Color(0xFFFE8000),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Auction Schedule",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Compact schedule info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFE8000).withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Start date
                      _buildEnhancedInfoRow(
                        icon: Icons.play_arrow_rounded,
                        iconColor: const Color(0xFFFE8000),
                        label: "Auction Starts",
                        value: controller.formattedStartDate,
                        isStart: true,
                      ),
                      const SizedBox(height: 12),

                      // Divider
                      Container(height: 1, color: Colors.grey.shade200),
                      const SizedBox(height: 12),

                      // End date
                      _buildEnhancedInfoRow(
                        icon: Icons.stop_rounded,
                        iconColor: Colors.grey.shade600,
                        label: "Auction Ends",
                        value: controller.formattedEndDate,
                        isStart: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Compact countdown
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFE8000),
                        const Color(0xFFFE8000).withValues(alpha: 0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFE8000).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.timer_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          controller.timeRemainingLabel.value,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(
                          () => Text(
                            controller.timeRemaining.value,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isStart,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isStart
                      ? const Color(0xFFFE8000)
                      : Colors.grey.shade800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade600.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Timer icon with background
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Countdown label
          Obx(
            () => Text(
              controller.timeRemainingLabel.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Countdown time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(
              () => Text(
                controller.timeRemaining.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionEndedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Simple header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Simple logo
                Container(
                  height: 45,
                  width: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/image/logo/001.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.gavel,
                            color: Colors.green.shade600,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Status and title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Completed',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Auction Ended",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Thank you for participating",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: const Color(0xFFFE8000),
                ),
                const SizedBox(height: 16),
                Text(
                  "Auction Successfully Completed",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "The bidding session has ended. Results will be announced soon.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Color _getCountdownColor() {
    switch (controller.auctionStatus.value) {
      case AuctionStatus.beforeStart:
        return const Color(0xFFFE8000); // Orange - waiting to start
      case AuctionStatus.active:
        return Colors.green.shade600; // Green - auction active
      case AuctionStatus.ended:
        return Colors.red.shade600; // Red - auction ended
    }
  }

  Color _getStatusColor() {
    switch (controller.auctionStatus.value) {
      case AuctionStatus.beforeStart:
        return Colors.blue.shade600; // Blue - upcoming
      case AuctionStatus.active:
        return Colors.green.shade600; // Green - live
      case AuctionStatus.ended:
        return Colors.red.shade600; // Red - closed
    }
  }

  IconData _getStatusIcon() {
    switch (controller.auctionStatus.value) {
      case AuctionStatus.beforeStart:
        return Icons.schedule; // Clock icon for upcoming
      case AuctionStatus.active:
        return Icons.live_tv; // Live icon for active
      case AuctionStatus.ended:
        return Icons.gavel; // Gavel icon for ended
    }
  }

  String _getStatusText() {
    switch (controller.auctionStatus.value) {
      case AuctionStatus.beforeStart:
        return 'Upcoming Auction';
      case AuctionStatus.active:
        return 'Live Auction';
      case AuctionStatus.ended:
        return 'Auction Closed';
    }
  }

  Widget _buildFeaturedAuctionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Featured Auctions",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final selectedCategory = controller.selectedCategory.value;
          final items = selectedCategory == 'All'
              ? controller.auctionItems
              : controller.auctionItems
                    .where((item) => item['category'] == selectedCategory)
                    .toList();
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildAuctionCard(item);
            },
          );
        }),
      ],
    );
  }

  Widget _buildAuctionCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => controller.onAuctionItemTap(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder with gradient
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey.shade200, Colors.grey.shade300],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.diamond, size: 40, color: Colors.grey),
                  ),
                  // Status badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "LIVE",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Current Bid: ${item['currentBid']}",
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFE8000),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['timeLeft'],
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveAuctionBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFE8000), Color(0xFFFF9500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🔴 Live Auction",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Join the live auction happening now!",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.onJoinLiveAuctionTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFE8000),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Join Now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.settings,
                  size: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Demo Controls",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.resetToBeforeStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Before Start",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.simulateAuctionStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Start Auction",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.simulateAuctionEnd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "End Auction",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
