import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/responsive_padding.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: controller.goBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.loadUserProfile,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: controller.goToUpdateProfile,
          ),
        ],
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) => Obx(() => controller.isLoadingProfile.value
          ? const Center(child: CircularProgressIndicator())
          : controller.userProfile.value == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Profile data not available',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.loadUserProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reload Profile'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(ResponsivePadding.getSmallSpacing(screenWidth)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      _buildProfileHeader(screenWidth, isTablet),

                      SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                      // Error/Success Messages
                      _buildMessages(),

                      // Profile Information
                      _buildProfileInformation(screenWidth, isTablet),

                      SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                      // Change Password Section
                      _buildChangePasswordSection(screenWidth, isTablet),

                      SizedBox(height: ResponsivePadding.largeSpacing),
                    ],
                  ),
                )),
      ),
    );
  }

  Widget _buildProfileHeader(double screenWidth, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(ResponsivePadding.getSmallSpacing(screenWidth)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFFFF9500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: isTablet ? 80 : 70,
            height: isTablet ? 80 : 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(isTablet ? 40 : 35),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person,
              size: isTablet ? 40 : 35,
              color: Colors.white,
            ),
          ),

          SizedBox(width: ResponsivePadding.getSmallSpacing(screenWidth)),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      controller.userProfile.value?.fullName ?? 'Loading...',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(height: 4),
                Obx(() => Text(
                      controller.userProfile.value?.email ?? '',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Icon(
                                controller.isVerified.value
                                    ? Icons.verified
                                    : Icons.pending,
                                size: 14,
                                color: Colors.white,
                              )),
                          const SizedBox(width: 4),
                          Obx(() => Text(
                                controller.isVerified.value ? 'Verified' : 'Pending',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                          'Balance: ${controller.formatBalance(controller.userProfile.value?.balance)}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Column(
      children: [
        Obx(() => controller.errorMessage.value.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.errorMessage.value = "",
                      icon: Icon(Icons.close, color: Colors.red.shade600, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink()),
        Obx(() => controller.successMessage.value.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.successMessage.value,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.successMessage.value = "",
                      icon: Icon(Icons.close, color: Colors.green.shade600, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildProfileInformation(double screenWidth, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(ResponsivePadding.getSmallSpacing(screenWidth)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Information',
                style: AppTypography.headlineSmall.copyWith(
                  fontSize: isTablet ? 20 : 18,
                  color: Colors.black87,
                ),
              ),
              ElevatedButton.icon(
                onPressed: controller.goToUpdateProfile,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),
          
          // Personal Details
          _buildInfoItem('Full Name', controller.userProfile.value?.fullName ?? 'N/A', Icons.person_outline),
          _buildInfoItem('Email', controller.userProfile.value?.email ?? 'N/A', Icons.email_outlined),
          _buildInfoItem('IC Number', controller.userProfile.value?.icNumber ?? 'N/A', Icons.credit_card_outlined),
          _buildInfoItem('Phone Number', controller.userProfile.value?.phoneNumber ?? 'N/A', Icons.phone_outlined),
          
          const SizedBox(height: 16),
          Text(
            'Address Information',
            style: AppTypography.titleMedium.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildInfoItem('Address Line 1', controller.userProfile.value?.address1 ?? 'N/A', Icons.home_outlined),
          _buildInfoItem('Address Line 2', controller.userProfile.value?.address2 ?? 'N/A', Icons.home_outlined),
          _buildInfoItem('Address Line 3', controller.userProfile.value?.address3 ?? 'N/A', Icons.home_outlined),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Postcode', controller.userProfile.value?.postcode ?? 'N/A', Icons.local_post_office_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem('City', controller.userProfile.value?.city ?? 'N/A', Icons.location_city_outlined),
              ),
            ],
          ),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('State', controller.userProfile.value?.state ?? 'N/A', Icons.map_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem('Country', controller.userProfile.value?.country ?? 'N/A', Icons.public_outlined),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Member Since (Read-only)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Member Since',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Obx(() => Text(
                          controller.formatMemberSince(controller.userProfile.value?.createdAt),
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController textController,
    IconData icon, {
    bool isRequired = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: AppTypography.labelMedium.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: textController,
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
              suffixIcon: onToggleVisibility != null
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordSection(double screenWidth, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(ResponsivePadding.getSmallSpacing(screenWidth)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Change Password',
            style: AppTypography.headlineSmall.copyWith(
              fontSize: isTablet ? 20 : 18,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),
          
          Obx(() => _buildPasswordField(
                'Current Password',
                controller.currentPasswordController,
                Icons.lock_outline,
                isRequired: true,
                obscureText: !controller.isCurrentPasswordVisible.value,
                onToggleVisibility: controller.toggleCurrentPasswordVisibility,
              )),
          
          Obx(() => _buildPasswordField(
                'New Password',
                controller.newPasswordController,
                Icons.lock_outline,
                isRequired: true,
                obscureText: !controller.isNewPasswordVisible.value,
                onToggleVisibility: controller.toggleNewPasswordVisibility,
              )),
          
          Obx(() => _buildPasswordField(
                'Confirm New Password',
                controller.confirmPasswordController,
                Icons.lock_outline,
                isRequired: true,
                obscureText: !controller.isConfirmPasswordVisible.value,
                onToggleVisibility: controller.toggleConfirmPasswordVisibility,
              )),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isChangingPassword.value
                      ? null
                      : controller.changePasswordFromForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsivePadding.getSmallSpacing(screenWidth),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isChangingPassword.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Change Password',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )),
          ),
        ],
      ),
    );
  }
} 