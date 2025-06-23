import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/user.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final icNumberController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  final postcodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  final isLoading = false.obs;
  final isLoadingProfile = false.obs;
  final isSaving = false.obs;
  final isChangingPassword = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final userProfile = Rx<User?>(null);
  final isVerified = false.obs;
  
  // Password visibility
  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  
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
    loadUserProfile();
  }
  
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    icNumberController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    address3Controller.dispose();
    postcodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  Future<void> loadUserProfile() async {
    isLoadingProfile.value = true;
    errorMessage.value = '';
    
    try {
      final userData = _storageService.getUser();
      if (userData != null) {
        userProfile.value = User.fromJson(userData);
        isVerified.value = userProfile.value?.isVerified ?? false;
        _populateFormFields();
      }
    } catch (e) {
      errorMessage.value = 'Failed to load profile data';
      print('Error loading profile: $e');
    }
    
    isLoadingProfile.value = false;
  }
  
  void _populateFormFields() {
    if (userProfile.value != null) {
      fullName.value = userProfile.value!.fullName;
      email.value = userProfile.value!.email;
      phoneNumber.value = userProfile.value?.phoneNumber ?? '';
      dateOfBirth.value = userProfile.value?.dateOfBirth ?? '';
      gender.value = userProfile.value?.gender ?? '';
      nationality.value = userProfile.value?.nationality ?? '';
      occupation.value = userProfile.value?.occupation ?? '';
      icNumber.value = userProfile.value?.icNumber ?? '';
      address1.value = userProfile.value?.address1 ?? '';
      address2.value = userProfile.value?.address2 ?? '';
      address3.value = userProfile.value?.address3 ?? '';
      postcode.value = userProfile.value?.postcode ?? '';
      city.value = userProfile.value?.city ?? '';
      state.value = userProfile.value?.state ?? '';
      country.value = userProfile.value?.country ?? '';
    }
  }
  
  Future<void> updateProfile() async {
    if (!validateForm()) return;
    
    isSaving.value = true;
    errorMessage.value = '';
    successMessage.value = '';
    
    try {
      // Create updated profile data
      final updatedData = {
        ...userProfile.value?.toJson() ?? {},
        'full_name': fullName.value,
        'email': email.value,
        'phone_number': phoneNumber.value,
        'date_of_birth': dateOfBirth.value,
        'gender': gender.value,
        'nationality': nationality.value,
        'occupation': occupation.value,
        'ic_number': icNumber.value,
        'address1': address1.value,
        'address2': address2.value,
        'address3': address3.value,
        'postcode': postcode.value,
        'city': city.value,
        'state': state.value,
        'country': country.value,
      };
      
      // Save to storage
      await _storageService.saveUser(updatedData);
      userProfile.value = User.fromJson(updatedData);
      successMessage.value = 'Profile updated successfully';
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
    } catch (e) {
      errorMessage.value = 'Failed to update profile';
      print('Error updating profile: $e');
    }
    
    isSaving.value = false;
  }
  
  Future<void> changePasswordFromForm() async {
    if (!validatePasswordForm()) return;
    
    isChangingPassword.value = true;
    errorMessage.value = '';
    successMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      successMessage.value = 'Password changed successfully';
      
      // Clear password fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } catch (e) {
      errorMessage.value = 'Failed to change password';
      print('Error changing password: $e');
    }
    
    isChangingPassword.value = false;
  }
  
  bool validateForm() {
    if (fullName.value.isEmpty || email.value.isEmpty || !GetUtils.isEmail(email.value)) {
      errorMessage.value = 'Please fill in all required fields correctly';
      return false;
    }
    return true;
  }
  
  bool validatePasswordForm() {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      errorMessage.value = 'Please fill in all password fields';
      return false;
    }
    
    if (newPassword != confirmPassword) {
      errorMessage.value = 'New passwords do not match';
      return false;
    }
    
    if (newPassword.length < 8) {
      errorMessage.value = 'Password must be at least 8 characters long';
      return false;
    }
    
    return true;
  }
  
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }
  
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  void goBack() {
    Get.back();
  }
  
  void goToUpdateProfile() {
    Get.toNamed('/update-profile');
  }
  
  String formatBalance(double? balance) {
    if (balance == null) return 'RM 0.00';
    return 'RM ${balance.toStringAsFixed(2)}';
  }
  
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
  
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
  
  Future<void> uploadAvatar() async {
    // Dummy implementation
    await Future.delayed(const Duration(seconds: 1));
    successMessage.value = 'Avatar uploaded successfully';
  }
  
  Future<void> removeAvatar() async {
    // Dummy implementation
    await Future.delayed(const Duration(seconds: 1));
    successMessage.value = 'Avatar removed successfully';
  }
}

 