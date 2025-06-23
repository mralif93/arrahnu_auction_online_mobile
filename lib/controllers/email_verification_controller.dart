import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class EmailVerificationController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Text controller
  final emailController = TextEditingController();
  
  // Observable variables
  final isLoading = false.obs;
  final isResending = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final email = ''.obs;
  final isVerified = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserEmail();
    // Initialize with email from previous screen if available
    final args = Get.arguments;
    if (args != null && args['email'] != null) {
      emailController.text = args['email'];
    }
  }
  
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
  
  void loadUserEmail() {
    final userData = _storageService.getUser();
    if (userData != null) {
      email.value = userData['email'] ?? '';
      emailController.text = email.value;
    }
  }
  
  Future<void> resendVerificationEmail(String email) async {
    if (isLoading.value) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Success
      Get.snackbar(
        'Success',
        'Verification email sent to $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to send verification email';
      Get.snackbar(
        'Error',
        'Failed to send verification email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> verifyEmail(String code) async {
    if (isLoading.value) return;
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate verification success
      isVerified.value = true;
      
      // Navigate to next screen or show success message
      Get.snackbar(
        'Success',
        'Email verified successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to home after delay
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = 'Invalid verification code';
      Get.snackbar(
        'Error',
        'Invalid verification code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
} 