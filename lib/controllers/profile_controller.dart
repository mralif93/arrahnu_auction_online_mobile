import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Observable variables
  final isLoading = false.obs;
  final isLoadingProfile = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final userProfile = Rx<User?>(null);
  final isVerified = false.obs;
  
  // Password change controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Password visibility
  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isChangingPassword = false.obs;
  
  // Form fields
  final fullName = ''.obs;
  final email = ''.obs;
  final phoneNumber = ''.obs;
  final dateOfBirth = ''.obs;
  final gender = ''.obs;
  final nationality = ''.obs;
  final occupation = ''.obs;
  final icNumber = ''.obs;
  final address1 = ''.obs;
  final address2 = ''.obs;
  final address3 = ''.obs;
  final postcode = ''.obs;
  final city = ''.obs;
  final state = ''.obs;
  final country = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
    debugPrint('🔍 ProfileController initialized');
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _loadUserFromStorage() {
    final storedUser = _storageService.getUser();
    if (storedUser != null) {
      userProfile.value = storedUser;
      isVerified.value = storedUser.isVerified;
    }
  }
  
  // Placeholder methods for future implementation
  Future<void> loadProfile() async {
    debugPrint('🔍 ProfileController: loadProfile not implemented');
  }
  
  Future<void> updateProfile() async {
    debugPrint('🔍 ProfileController: updateProfile not implemented');
  }
  
  Future<void> uploadAvatar() async {
    debugPrint('🔍 ProfileController: uploadAvatar not implemented');
  }
  
  Future<void> removeAvatar() async {
    debugPrint('🔍 ProfileController: removeAvatar not implemented');
  }
  
  Future<void> changePassword(String current, String newPassword, String confirm) async {
    debugPrint('🔍 ProfileController: changePassword not implemented');
  }

  // Change password with controllers
  Future<void> changePasswordFromForm() async {
    final current = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();
    
    await changePassword(current, newPassword, confirm);
  }

  // Navigation methods
  void goBack() {
    Get.back();
  }

  Future<void> loadUserProfile() async {
    isLoadingProfile.value = true;
    errorMessage.value = '';
    
    try {
      // Simulate loading user profile
      await Future.delayed(const Duration(seconds: 1));
      _loadUserFromStorage(); // Reload from storage
      debugPrint('🔍 ProfileController: loadUserProfile not implemented');
    } catch (e) {
      errorMessage.value = 'Failed to load user profile';
      debugPrint('🚨 ProfileController: Error loading profile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void goToUpdateProfile() {
    Get.toNamed('/update-profile');
  }

  // Format balance for display
  String formatBalance(double? balance) {
    if (balance == null) return 'RM 0.00';
    return 'RM ${balance.toStringAsFixed(2)}';
  }

  // Format member since date
  String formatMemberSince(String? createdAt) {
    if (createdAt == null) return 'Unknown';
    try {
      final date = DateTime.parse(createdAt);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  // Password visibility toggles
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
}

 