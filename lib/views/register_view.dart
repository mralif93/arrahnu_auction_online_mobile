import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_padding.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(child: _buildResponsiveLayout(context)),
          ),
        ),
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
    return Column(
      children: [
        // Sticky Logo Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: ResponsivePadding.largeSpacing * 2,
            bottom: ResponsivePadding.smallSpacing
          ),
          decoration: BoxDecoration(color: AppColors.background),
          child: Center(
            child: SizedBox(
              height: 100,
              child: Image.asset(
                'assets/images/logo/001.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: AppTheme.mediumRadius,
                    ),
                    child: Icon(
                      Icons.account_balance,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            padding: AppTheme.getPadding(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Compact Welcome Text
                  Text(
                    "Create Account",
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: ResponsivePadding.smallSpacing / 2),

                  Text(
                    "Join us today",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: ResponsivePadding.sectionSpacing),

                  // Compact Register Form
                  _buildCompactRegisterForm(),

                  SizedBox(height: ResponsivePadding.smallSpacing),

                  // Compact Terms Section
                  _buildCompactTermsSection(),

                  SizedBox(height: ResponsivePadding.smallSpacing),

                  // Compact Register Button
                  _buildCompactRegisterButton(),

                  SizedBox(height: ResponsivePadding.smallSpacing),

                  // Compact Sign In Link
                  _buildCompactSignInLink(),

                  SizedBox(height: ResponsivePadding.largeSpacing),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(
        8,
      ), // Reduced from responsive padding to match home page
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: screenWidth >= 1024 ? 10 : 8,
          ), // Reduced top spacing to match home page
          // Logo Image Section - 50% Width for Tablets
          _buildTabletLogo(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 16 : 14),

          // Welcome Text - Tablet optimized
          Text(
            "Create Account",
            style: _getTabletTitleStyle(screenWidth).copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth >= 1024 ? 8 : 6),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth >= 1024 ? 32 : 28,
            ),
            child: Text(
              "Join Ar-Rahnu Auction today",
              style: _getTabletSubtitleStyle(screenWidth).copyWith(
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: screenWidth >= 1024 ? 20 : 18),

          // Register Form - Tablet optimized
          _buildTabletRegisterForm(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 14 : 12),

          // Terms and Conditions - Tablet optimized
          _buildTabletTermsSection(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 18 : 16),

          // Register Button - Tablet optimized
          _buildTabletRegisterButton(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 18 : 16),

          // Sign In Link - Tablet optimized
          _buildTabletSignInLink(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 14 : 12),
        ],
      ),
    );
  }

  Widget _buildCompactRegisterForm() {
    return Column(
      children: [
        // Personal Information Section
        _buildSectionHeader("Personal Information", Icons.person_outline),
        const SizedBox(height: 12),

        // Full Name Field
        _buildCompactTextField(
          controller: controller.fullNameController,
          hintText: "Full Name",
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // IC Number Field
        _buildCompactTextField(
          controller: controller.icNumberController,
          hintText: "Identification Card Number",
          icon: Icons.credit_card_outlined,
          keyboardType: TextInputType.text,
        ),

        SizedBox(height: ResponsivePadding.sectionSpacing),

        // Contact Information Section
        _buildSectionHeader(
          "Contact Information",
          Icons.contact_phone_outlined,
        ),
        const SizedBox(height: 12),

        // Email Field
        _buildCompactTextField(
          controller: controller.emailController,
          hintText: "Email Address",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // Phone Number Field
        _buildCompactTextField(
          controller: controller.phoneController,
          hintText: "Phone Number",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),

        SizedBox(height: ResponsivePadding.sectionSpacing),

        // Address Information Section
        _buildSectionHeader("Address Information", Icons.location_on_outlined),
        const SizedBox(height: 12),

        // Address Line 1
        _buildCompactTextField(
          controller: controller.address1Controller,
          hintText: "Address Line 1",
          icon: Icons.home_outlined,
          keyboardType: TextInputType.streetAddress,
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // Address Line 2
        _buildCompactTextField(
          controller: controller.address2Controller,
          hintText: "Address Line 2 (Optional)",
          icon: Icons.home_work_outlined,
          keyboardType: TextInputType.streetAddress,
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // Address Line 3
        _buildCompactTextField(
          controller: controller.address3Controller,
          hintText: "Address Line 3 (Optional)",
          icon: Icons.apartment_outlined,
          keyboardType: TextInputType.streetAddress,
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // Postcode Field (Full Width)
        _buildCompactTextField(
          controller: controller.postcodeController,
          hintText: "Postcode",
          icon: Icons.markunread_mailbox_outlined,
          keyboardType: TextInputType.number,
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // City Field (Full Width)
        _buildCompactTextField(
          controller: controller.cityController,
          hintText: "City",
          icon: Icons.location_city_outlined,
          keyboardType: TextInputType.text,
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // State Field (Full Width)
        _buildCompactTextField(
          controller: controller.stateController,
          hintText: "State",
          icon: Icons.map_outlined,
          keyboardType: TextInputType.text,
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // Country Field (Full Width)
        _buildCompactTextField(
          controller: controller.countryController,
          hintText: "Country",
          icon: Icons.public_outlined,
          keyboardType: TextInputType.text,
        ),

        SizedBox(height: ResponsivePadding.sectionSpacing),

        // Security Information Section
        _buildSectionHeader("Security Information", Icons.security_outlined),
        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // Password Field
        Obx(
          () => _buildCompactPasswordField(
            controller: controller.passwordController,
            hintText: "Password",
            isVisible: controller.isPasswordVisible.value,
            onToggleVisibility: controller.togglePasswordVisibility,
          ),
        ),

        SizedBox(height: ResponsivePadding.formFieldSpacing),

        // Confirm Password Field
        Obx(
          () => _buildCompactPasswordField(
            controller: controller.confirmPasswordController,
            hintText: "Confirm Password",
            isVisible: controller.isConfirmPasswordVisible.value,
            onToggleVisibility: controller.toggleConfirmPasswordVisibility,
          ),
        ),
      ],
    );
  }

  // Helper method to build section headers
  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: AppTheme.getPadding(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppTheme.smallRadius,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          SizedBox(width: ResponsivePadding.smallSpacing),
          Text(
            title,
            style: AppTypography.labelMedium.copyWith(
              fontWeight: AppTypography.semiBold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build compact text fields
  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return SizedBox(
      height: 48, // Fixed height for consistency
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTypography.bodyMedium,
        decoration: AppTheme.inputDecoration.copyWith(
          hintText: hintText,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textLight,
          ),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
          isDense: true, // Makes the field more compact
        ),
      ),
    );
  }

  // Helper method to build compact password fields
  Widget _buildCompactPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: AppTypography.bodyMedium,
      decoration: AppTheme.inputDecoration.copyWith(
        hintText: hintText,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textLight,
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: AppColors.primary,
          size: 18,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
            size: 18,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }

  Widget _buildCompactTermsSection() {
    return Row(
      children: [
        Obx(
          () => Transform.scale(
            scale: 0.8,
            child: Checkbox(
              value: controller.agreeToTerms.value,
              onChanged: controller.toggleAgreeToTerms,
              activeColor: AppColors.primary,
              checkColor: AppColors.textWhite,
              side: BorderSide(color: AppColors.border, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.getRadius(4),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        SizedBox(width: ResponsivePadding.smallSpacing / 2),
        Expanded(
          child: Wrap(
            children: [
              Text(
                "I agree to the ",
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: controller.onTermsAndConditionsTap,
                child: Text(
                  "Terms & Conditions",
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTypography.semiBold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactRegisterButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : controller.handleRegister,
        style: AppTheme.primaryButtonStyle.copyWith(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 14),
          ),
          elevation: WidgetStateProperty.all(2),
          shadowColor: WidgetStateProperty.all(
            AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: controller.isLoading.value
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: AppColors.textWhite,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Create Account",
                style: AppTypography.buttonText,
              ),
      ),
    );
  }

  Widget _buildCompactSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: controller.onSignInTap,
          child: Text(
            "Sign In",
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: AppTypography.semiBold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // Tablet responsive helper methods

  TextStyle _getTabletTitleStyle(double screenWidth) {
    if (screenWidth >= 1194) return AppTypography.headlineLarge; // 14" tablets
    if (screenWidth >= 1112) return AppTypography.headlineLarge; // 13" tablets
    if (screenWidth >= 1024) return AppTypography.headlineMedium; // 12" tablets
    if (screenWidth >= 834) return AppTypography.headlineSmall; // 11" tablets
    return AppTypography.titleLarge; // 10" tablets
  }

  TextStyle _getTabletSubtitleStyle(double screenWidth) {
    if (screenWidth >= 1194) return AppTypography.titleLarge; // 14" tablets
    if (screenWidth >= 1112) return AppTypography.titleMedium; // 13" tablets
    if (screenWidth >= 1024) return AppTypography.titleMedium; // 12" tablets
    if (screenWidth >= 834) return AppTypography.titleSmall; // 11" tablets
    return AppTypography.bodyLarge; // 10" tablets
  }

  Widget _buildTabletLogo(double screenWidth) {
    final logoHeight = _getTabletLogoHeight(screenWidth);

    return Container(
      width: double.infinity,
      margin: AppTheme.getPadding(
        horizontal: screenWidth >= 1024 ? 24 : 20,
        vertical: screenWidth >= 1024 ? 12 : 10,
      ),
      child: Center(
        child: Container(
          height: logoHeight,
          padding: AppTheme.getPadding(
            horizontal: screenWidth >= 1024 ? 32 : 24,
          ),
          child: Image.asset(
            'assets/images/logo/001.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: logoHeight,
                padding: AppTheme.getPadding(
                  horizontal: screenWidth >= 1024 ? 20 : 16,
                  vertical: screenWidth >= 1024 ? 20 : 16
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppTheme.getRadius(
                    screenWidth >= 1024 ? 16 : 12,
                  ),
                ),
                child: Icon(
                  Icons.account_balance,
                  size: logoHeight * 0.6,
                  color: AppColors.primary,
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

  Widget _buildTabletRegisterForm(double screenWidth) {
    final fieldSpacing = screenWidth >= 1024 ? 
      ResponsivePadding.largeSpacing : 
      ResponsivePadding.sectionSpacing;
    final fontSize = screenWidth >= 1024 ? AppTypography.lg : AppTypography.base;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        Text(
          "Full Name",
          style: AppTypography.titleMedium.copyWith(
            fontSize: fontSize,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsivePadding.smallSpacing),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: screenWidth >= 1024 ? 12 : 8,
                offset: Offset(0, screenWidth >= 1024 ? 3 : 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.fullNameController,
            style: AppTypography.bodyLarge.copyWith(
              fontSize: fontSize,
            ),
            decoration: AppTheme.inputDecoration.copyWith(
              hintText: "Enter your full name",
              hintStyle: AppTypography.bodyLarge.copyWith(
                fontSize: fontSize,
                color: AppColors.textLight,
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: screenWidth >= 1024 ? 24 : 22,
              ),
              contentPadding: AppTheme.getPadding(
                horizontal: screenWidth >= 1024 ? 24 : 20,
                vertical: screenWidth >= 1024 ? 22 : 20,
              ),
            ),
          ),
        ),
        SizedBox(height: fieldSpacing),

        // Email Field
        Text(
          "Email Address",
          style: AppTypography.titleMedium.copyWith(
            fontSize: fontSize,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsivePadding.smallSpacing),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: screenWidth >= 1024 ? 12 : 8,
                offset: Offset(0, screenWidth >= 1024 ? 3 : 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.emailController,
            style: AppTypography.bodyLarge.copyWith(
              fontSize: fontSize,
            ),
            decoration: AppTheme.inputDecoration.copyWith(
              hintText: "Enter your email address",
              hintStyle: AppTypography.bodyLarge.copyWith(
                fontSize: fontSize,
                color: AppColors.textLight,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppColors.primary,
                size: screenWidth >= 1024 ? 24 : 22,
              ),
              contentPadding: AppTheme.getPadding(
                horizontal: screenWidth >= 1024 ? 24 : 20,
                vertical: screenWidth >= 1024 ? 22 : 20,
              ),
            ),
          ),
        ),
        SizedBox(height: fieldSpacing),

        // Password Field
        Text(
          "Password",
          style: AppTypography.titleMedium.copyWith(
            fontSize: fontSize,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsivePadding.smallSpacing),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: screenWidth >= 1024 ? 12 : 8,
                offset: Offset(0, screenWidth >= 1024 ? 3 : 2),
              ),
            ],
          ),
          child: Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              style: AppTypography.bodyLarge.copyWith(
                fontSize: fontSize,
              ),
              decoration: AppTheme.inputDecoration.copyWith(
                hintText: "Create a strong password",
                hintStyle: AppTypography.bodyLarge.copyWith(
                  fontSize: fontSize,
                  color: AppColors.textLight,
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.primary,
                  size: screenWidth >= 1024 ? 24 : 22,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    !controller.isPasswordVisible.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade600,
                    size: screenWidth >= 1024 ? 24 : 22,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                contentPadding: AppTheme.getPadding(
                  horizontal: screenWidth >= 1024 ? 24 : 20,
                  vertical: screenWidth >= 1024 ? 22 : 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletTermsSection(double screenWidth) {
    return Container(
      padding: AppTheme.getPadding(
        vertical: screenWidth >= 1024 ? 
          ResponsivePadding.sectionSpacing : 
          ResponsivePadding.smallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => Transform.scale(
              scale: screenWidth >= 1024 ? 1.2 : 1.1,
              child: Checkbox(
                value: controller.agreeToTerms.value,
                onChanged: controller.toggleAgreeToTerms,
                activeColor: AppColors.primary,
                checkColor: AppColors.textWhite,
                side: BorderSide(color: AppColors.border, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.getRadius(
                    screenWidth >= 1024 ? 10 : 8,
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          SizedBox(width: ResponsivePadding.smallSpacing),
          Expanded(
            child: Wrap(
              children: [
                Text(
                  "I agree to the ",
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: controller.onTermsAndConditionsTap,
                  child: Text(
                    "Terms & Conditions",
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTypography.semiBold,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletRegisterButton(double screenWidth) {
    final buttonHeight = screenWidth >= 1024 ? 56.0 : 52.0;

    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: screenWidth >= 1024 ? 16 : 12,
            offset: Offset(0, screenWidth >= 1024 ? 6 : 4),
          ),
        ],
      ),
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.handleRegister,
          style: AppTheme.primaryButtonStyle.copyWith(
            padding: WidgetStateProperty.all(
              AppTheme.getPadding(
                vertical: screenWidth >= 1024 ? 18 : 16,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: AppTheme.getRadius(
                  screenWidth >= 1024 ? 16 : 12,
                ),
              ),
            ),
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: screenWidth >= 1024 ? 26 : 22,
                  height: screenWidth >= 1024 ? 26 : 22,
                  child: CircularProgressIndicator(
                    color: AppColors.textWhite,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  "Create Account",
                  style: screenWidth >= 1024 
                    ? AppTypography.headlineSmall 
                    : AppTypography.titleLarge,
                ),
        ),
      ),
    );
  }

  Widget _buildTabletSignInLink(double screenWidth) {
    final textStyle = screenWidth >= 1024 
        ? AppTypography.titleMedium 
        : AppTypography.titleSmall;

    return Container(
      padding: AppTheme.getPadding(
        vertical: screenWidth >= 1024 
          ? ResponsivePadding.sectionSpacing 
          : ResponsivePadding.smallSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: textStyle.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: controller.onSignInTap,
            child: Container(
              padding: AppTheme.getPadding(
                horizontal: ResponsivePadding.smallSpacing / 2,
                vertical: ResponsivePadding.smallSpacing / 4,
              ),
              child: Text(
                "Sign In",
                style: textStyle.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.semiBold,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
