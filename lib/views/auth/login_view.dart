import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_typography.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive_padding.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
          decoration: BoxDecoration(
            color: AppColors.background,
          ),
          child: Container(
            margin: AppTheme.getPadding(horizontal: 16),
            child: Center(
              child: Container(
                height: 80,
                padding: AppTheme.getPadding(horizontal: 20),
                child: Image.asset(
                  'assets/images/logo/001.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 80,
                      padding: AppTheme.getPadding(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
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
                    "Welcome Back",
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: ResponsivePadding.smallSpacing / 2),

                  Text(
                    "Sign in to continue",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: ResponsivePadding.sectionSpacing),

                  // Compact Login Form
                  _buildCompactLoginForm(),

                  SizedBox(height: ResponsivePadding.smallSpacing),

                  // Compact Remember Me & Forgot Password
                  _buildCompactRememberMeSection(),

                  SizedBox(height: ResponsivePadding.smallSpacing),

                  // Compact Login Button
                  _buildCompactLoginButton(),

                  SizedBox(height: ResponsivePadding.smallSpacing),

                  // Compact Sign Up Link
                  _buildCompactSignUpLink(),

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
      padding: AppTheme.getPadding(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: screenWidth >= 1024 ? ResponsivePadding.smallSpacing : 8,
          ),
          // Logo Image Section - 50% Width for Tablets
          _buildTabletLogo(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? ResponsivePadding.smallSpacing : 14),

          // Welcome Text - Tablet optimized
          Text(
            "Welcome Back!",
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: _getTabletTitleFontSize(screenWidth),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth >= 1024 ? 8 : 6),

          Container(
            padding: AppTheme.getPadding(
              horizontal: screenWidth >= 1024 ? 32 : 28,
            ),
            child: Text(
              "Sign in to your account",
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: _getTabletSubtitleFontSize(screenWidth),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: screenWidth >= 1024 ? ResponsivePadding.largeSpacing : 18),

          // Login Form - Tablet optimized
          _buildTabletLoginForm(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? ResponsivePadding.smallSpacing : 12),

          // Remember Me & Forgot Password - Tablet optimized
          _buildTabletRememberMeSection(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? ResponsivePadding.smallSpacing : 16),

          // Login Button - Tablet optimized
          _buildTabletLoginButton(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? ResponsivePadding.smallSpacing : 16),

          // Sign Up Link - Tablet optimized
          _buildTabletSignUpLink(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? ResponsivePadding.smallSpacing : 12),
        ],
      ),
    );
  }

  Widget _buildCompactLoginForm() {
    return Column(
      children: [
        // Compact Email Field
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          style: AppTypography.bodyMedium,
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: "Email address",
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.primary,
              size: 18,
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFFE8000),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Compact Password Field
        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            style: AppTypography.bodyMedium,
            decoration: AppTheme.inputDecoration.copyWith(
              hintText: "Password",
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
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactRememberMeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(
              () => Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: controller.toggleRememberMe,
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
            Text(
              "Remember me",
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: controller.onForgotPasswordTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color(0xFFFE8000),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLoginButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.handleLogin,
        style: AppTheme.primaryButtonStyle.copyWith(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 14),
          ),
          elevation: MaterialStateProperty.all(2),
          shadowColor: MaterialStateProperty.all(
            AppColors.primary.withOpacity(0.3),
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
                "Sign In",
                style: AppTypography.buttonText,
              ),
      ),
    );
  }

  Widget _buildCompactSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: controller.onSignUpTap,
          child: Text(
            "Sign Up",
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
  double _getTabletTitleFontSize(double screenWidth) {
    if (screenWidth >= 1194) return AppTypography.xl4; // 14" tablets
    if (screenWidth >= 1112) return AppTypography.xl3; // 13" tablets
    if (screenWidth >= 1024) return AppTypography.xl2; // 12" tablets
    if (screenWidth >= 834) return AppTypography.xl; // 11" tablets
    return AppTypography.lg; // 10" tablets
  }

  double _getTabletSubtitleFontSize(double screenWidth) {
    if (screenWidth >= 1194) return AppTypography.base; // 14" tablets
    if (screenWidth >= 1112) return AppTypography.sm; // 13" tablets
    if (screenWidth >= 1024) return AppTypography.sm; // 12" tablets
    if (screenWidth >= 834) return AppTypography.sm; // 11" tablets
    return AppTypography.xs; // 10" tablets
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
                padding: AppTheme.getPadding(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: AppTheme.mediumRadius,
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

  Widget _buildTabletLoginForm(double screenWidth) {
    final fieldSpacing = screenWidth >= 1024 ? ResponsivePadding.largeSpacing : 18.0;
    final fontSize = screenWidth >= 1024 ? AppTypography.lg : AppTypography.base;
    final labelFontSize = screenWidth >= 1024 ? AppTypography.lg : AppTypography.base;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        Text(
          "Email Address",
          style: AppTypography.titleMedium.copyWith(
            fontSize: labelFontSize,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: screenWidth >= 1024 ? 10 : 8),
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
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
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
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontSize: labelFontSize,
          ),
        ),
        SizedBox(height: screenWidth >= 1024 ? 10 : 8),
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
                hintText: "Enter your password",
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
                    color: AppColors.textSecondary,
                    size: screenWidth >= 1024 ? 24 : 22,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
                  borderSide: BorderSide(color: AppColors.border, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 16 : 12),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
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

  Widget _buildTabletRememberMeSection(double screenWidth) {
    final fontSize = screenWidth >= 1024 ? AppTypography.base : AppTypography.sm;

    return Container(
      padding: AppTheme.getPadding(
        vertical: screenWidth >= 1024 ? 6 : 4
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Transform.scale(
                  scale: screenWidth >= 1024 ? 1.2 : 1.1,
                  child: Checkbox(
                    value: controller.rememberMe.value,
                    onChanged: controller.toggleRememberMe,
                    activeColor: AppColors.primary,
                    checkColor: AppColors.textWhite,
                    side: BorderSide(color: AppColors.border, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.getRadius(screenWidth >= 1024 ? 10 : 8),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              SizedBox(width: ResponsivePadding.smallSpacing),
              Text(
                "Remember me",
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: controller.onForgotPasswordTap,
            child: Text(
              "Forgot Password?",
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.primary,
                fontSize: fontSize,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLoginButton(double screenWidth) {
    final buttonHeight = screenWidth >= 1024 ? 56.0 : 52.0;
    final fontSize = screenWidth >= 1024 ? AppTypography.xl : AppTypography.lg;
    final borderRadius = screenWidth >= 1024 ? 16.0 : 12.0;

    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: AppTheme.getRadius(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: screenWidth >= 1024 ? 16 : 12,
            offset: Offset(0, screenWidth >= 1024 ? 6 : 4),
          ),
        ],
      ),
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.handleLogin,
          style: AppTheme.primaryButtonStyle.copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: AppTheme.getRadius(borderRadius),
              ),
            ),
            elevation: MaterialStateProperty.all(0),
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
                  "Sign In",
                  style: AppTypography.buttonText.copyWith(
                    fontSize: fontSize,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTabletSignUpLink(double screenWidth) {
    final fontSize = screenWidth >= 1024 ? AppTypography.lg : AppTypography.base;

    return Container(
      padding: AppTheme.getPadding(
        vertical: screenWidth >= 1024 ? 10 : 8
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontSize: fontSize,
            ),
          ),
          GestureDetector(
            onTap: controller.onSignUpTap,
            child: Container(
              padding: AppTheme.getPadding(
                horizontal: screenWidth >= 1024 ? 6 : 4,
                vertical: screenWidth >= 1024 ? 3 : 2,
              ),
              child: Text(
                "Sign Up",
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontSize: fontSize,
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
