import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_padding.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Forgot Password",
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: AppTypography.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppTheme.getPadding(
              horizontal: ResponsivePadding.getTabletPadding(screenWidth),
              vertical: ResponsivePadding.getSmallSpacing(screenWidth),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Icon Section
                Container(
                  width: ResponsivePadding.isTabletSize(screenWidth) ? 70 : 60,
                  height: ResponsivePadding.isTabletSize(screenWidth) ? 70 : 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppTheme.largeRadius,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: ResponsivePadding.isTabletSize(screenWidth) ? 35 : 30,
                    color: AppColors.textWhite,
                  ),
                ),

                SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),

                // Title Text
                Text(
                  "Reset Password",
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth) / 2),

                // Description Text
                Text(
                  "Enter your email address and we'll send you a link to reset your password",
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Email Form
                _buildEmailForm(controller, screenWidth),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Send Reset Link Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.handleForgotPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      padding: AppTheme.getPadding(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.smallRadius,
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.textWhite,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Send Reset Link",
                            style: AppTypography.buttonText.copyWith(
                              fontSize: AppTypography.base,
                              fontWeight: AppTypography.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  )),
                ),

                SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),

                // Error Message
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: AppTheme.smallRadius,
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          controller.errorMessage.value,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink()),

                // Success Message
                Obx(() => controller.successMessage.value.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: AppTheme.smallRadius,
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          controller.successMessage.value,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink()),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth) / 2),

                // Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remember your password? ",
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextButton(
                      onPressed: controller.onBackToLoginTap,
                      child: Text(
                        "Sign In",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTypography.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(ForgotPasswordController controller, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        Text(
          "Email Address",
          style: AppTypography.titleSmall.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth) / 2),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: "Enter your email address",
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.textLight),
            contentPadding: ResponsivePadding.getInputContentPadding(screenWidth),
          ),
        ),
      ],
    );
  }
} 