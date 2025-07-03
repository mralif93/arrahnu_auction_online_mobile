import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_typography.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive_padding.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
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
    final isTablet = screenWidth >= 768;

    return Column(
      children: [
        // Back Button
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: controller.onBackToLoginTap,
            icon: Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
            label: Text(
              'Back to Login',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            style: TextButton.styleFrom(
              padding: AppTheme.getPadding(horizontal: 16, vertical: 8),
            ),
          ),
        ),

        // Logo
        Container(
          width: double.infinity,
          child: Container(
            margin: AppTheme.getPadding(horizontal: 16),
            child: Center(
              child: Container(
                padding: AppTheme.getPadding(horizontal: 20),
                child: Image.asset(
                  'assets/images/logo/001.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
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

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: AppTheme.getPadding(
              horizontal: isTablet ? 32 : 24,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    "Forgot Password",
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: ResponsivePadding.smallSpacing / 2),

                  // Description
                  Text(
                    "Enter your email address and we'll send you instructions to reset your password",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: ResponsivePadding.sectionSpacing),

                  // Email Field
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
                    ),
                  ),

                  SizedBox(height: ResponsivePadding.sectionSpacing),

                  // Submit Button
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.handleForgotPassword,
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
                              "Send Instructions",
                              style: AppTypography.buttonText,
                            ),
                    ),
                  ),

                  SizedBox(height: ResponsivePadding.largeSpacing),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} 