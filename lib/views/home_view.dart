import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'branch_accounts_view.dart';

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
      padding: const EdgeInsets.all(8), // Reduced from ResponsivePadding.mobile
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ), // Reduced from ResponsivePadding.smallSpacing (10)
          // Logo Section
          _buildLogo(),

          const SizedBox(
            height: 12,
          ), // Reduced from ResponsivePadding.sectionSpacing (16)
          // Conditional Content Based on Auction Status
          Obx(() {
            final status = controller.auctionStatus.value;
            if (status == AuctionStatus.beforeStart ||
                status == AuctionStatus.ended) {
              // Before start or ended - only show session info
              return Column(
                children: [
                  _buildBiddingSessionInfo(),
                  const SizedBox(height: 16),
                ],
              );
            } else if (status == AuctionStatus.active) {
              // During auction - show branch list for hierarchical navigation
              return Column(
                children: [
                  // Branch List Section
                  _buildBranchListSection(),
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
    return Padding(
      padding: const EdgeInsets.all(8), // Reduced from responsive padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenWidth >= 1024 ? 10 : 8), // Reduced top spacing
          // Logo Section - Tablet optimized
          _buildTabletLogo(screenWidth),

          SizedBox(
            height: screenWidth >= 1024 ? 16 : 12,
          ), // Reduced section spacing
          // Conditional Content Based on Auction Status
          Obx(() {
            final status = controller.auctionStatus.value;
            if (status == AuctionStatus.beforeStart ||
                status == AuctionStatus.ended) {
              // Before start or ended - tablet layout
              return Column(
                children: [
                  _buildBiddingSessionInfo(),
                  const SizedBox(height: 20),
                ],
              );
            } else if (status == AuctionStatus.active) {
              // During auction - tablet layout
              return Column(
                children: [
                  // Featured Auctions Section - Tablet grid
                  _buildTabletFeaturedAuctionsSection(screenWidth),
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

  Widget _buildTabletLogo(double screenWidth) {
    final logoHeight = _getTabletLogoHeight(screenWidth);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth >= 1024 ? 24 : 20,
        vertical: screenWidth >= 1024 ? 12 : 10,
      ),
      child: Center(
        child: Container(
          height: logoHeight,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth >= 1024 ? 32 : 24,
          ),
          child: Image.asset(
            'assets/images/logo/001.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: logoHeight,
                padding: EdgeInsets.all(screenWidth >= 1024 ? 20 : 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    screenWidth >= 1024 ? 16 : 12,
                  ),
                ),
                child: Icon(
                  Icons.account_balance,
                  size: logoHeight * 0.6,
                  color: const Color(0xFFFE8000),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _getTabletLogoHeight(double screenWidth) {
    if (screenWidth >= 1194) {
      return 100.0; // 14" tablets - Optimized for card-less design
    }
    if (screenWidth >= 1112) return 95.0; // 13" tablets
    if (screenWidth >= 1024) return 90.0; // 12" tablets
    if (screenWidth >= 834) return 85.0; // 11" tablets
    return 80.0; // 10" tablets
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
    if (screenWidth >= 1194) {
      return 0.85; // 14" tablets - Adjusted for increased card height
    }
    if (screenWidth >= 1112) return 0.83; // 13" tablets
    if (screenWidth >= 1024) return 0.80; // 12" tablets
    if (screenWidth >= 834) return 0.78; // 11" tablets
    return 0.75; // 10" tablets
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
          // Image section - Reduced height
          Container(
            height: screenWidth >= 1024 ? 120 : 100,
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
                size: screenWidth >= 1024 ? 40 : 32,
                color: Colors.grey.shade400,
              ),
            ),
          ),

          // Content section - Fixed height to prevent overflow
          Container(
            height: screenWidth >= 1024
                ? 120
                : 105, // Increased height for more info
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
                  maxLines: 1, // Reduced to single line
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth >= 1024 ? 4 : 3),
                // Branch and Account info
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: screenWidth >= 1024 ? 14 : 12,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${item['branchName']?.split(' ')[0] ?? 'Branch'} • ${item['accountNumber'] ?? 'ACC'}",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: screenWidth >= 1024 ? 12 : 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth >= 1024 ? 6 : 4),
                Text(
                  item['currentBid'] ?? 'RM 0',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: priceFontSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFE8000),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: screenWidth >= 1024 ? 14 : 12,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        item['timeLeft'] ?? '2h 30m',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: detailFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth >= 1024 ? 6 : 4,
                          vertical: screenWidth >= 1024 ? 3 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['purity'] ?? 'N/A',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: screenWidth >= 1024 ? 11 : 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
      child: Center(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            'assets/images/logo/001.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 80,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance,
                  size: 48,
                  color: const Color(0xFFFE8000),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBiddingSessionInfo() {
    return Obx(() {
      final isEnded = controller.auctionStatus.value == AuctionStatus.ended;

      if (isEnded) {
        return _buildSimpleEndedCard();
      } else {
        return _buildUpcomingAuctionCard();
      }
    });
  }

  Widget _buildSimpleEndedCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.08),
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
          // Header section with logo and status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.withValues(alpha: 0.08),
                  Colors.green.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Logo container
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.1),
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
                          color: Colors.green,
                          size: 20,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Title and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
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
                              'Auction Closed',
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

                      // Title
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
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current date
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
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.today, size: 16, color: Colors.green),
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

                // Auction completion section
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.event_available,
                        size: 14,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Auction Completed",
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

                // Completion details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Start date
                      _buildCompletionInfoRow(
                        icon: Icons.play_arrow_rounded,
                        iconColor: Colors.green,
                        label: "Auction Started",
                        value: controller.formattedStartDate,
                        isCompleted: true,
                      ),
                      const SizedBox(height: 12),

                      // Divider
                      Container(height: 1, color: Colors.grey.shade200),
                      const SizedBox(height: 12),

                      // End date
                      _buildCompletionInfoRow(
                        icon: Icons.stop_rounded,
                        iconColor: Colors.green,
                        label: "Auction Ended",
                        value: controller.formattedEndDate,
                        isCompleted: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Success status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green,
                        Colors.green.withValues(alpha: 0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
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
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Auction Successfully Completed',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
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
                        child: Text(
                          'Results Available Soon',
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

  Widget _buildCompletionInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isCompleted,
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
                  color: isCompleted ? Colors.green : Colors.grey.shade800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Completion checkmark
        if (isCompleted)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.check, size: 12, color: Colors.green),
          ),
      ],
    );
  }

  Widget _buildBranchListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ), // Reduced padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Auction Branches',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.location_on, color: const Color(0xFFFE8000), size: 24),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Branch cards
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ), // Reduced padding
          child: Column(
            children: controller.auctionData.keys.map((branchName) {
              final branchData = controller.auctionsByBranch[branchName] ?? [];
              final itemCount = branchData.length;
              final accountCount =
                  controller.auctionData[branchName]?.keys.length ?? 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildBranchCard(branchName, accountCount, itemCount),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchCard(String branchName, int accountCount, int itemCount) {
    return GestureDetector(
      onTap: () => _navigateToBranchAccounts(branchName),
      child: Container(
        padding: const EdgeInsets.all(12), // Reduced padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFE8000).withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Branch icon
            Container(
              padding: const EdgeInsets.all(8), // Reduced padding
              decoration: BoxDecoration(
                color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.business,
                color: const Color(0xFFFE8000),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Branch info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branchName,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$accountCount accounts • $itemCount items',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBranchAccounts(String branchName) {
    Get.to(() => BranchAccountsView(branchName: branchName));
  }
}
