import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = AuthService();
  
  // Text editing controllers
  final emailController = TextEditingController();

  // Observable variables
  var isLoading = false.obs;
  var emailSent = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    _authService.dispose();
    super.onClose();
  }

  void onBackToLoginTap() {
    Get.back();
  }

  Future<void> handleForgotPassword() async {
    // Validate input
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    // Email format validation
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.forgotPassword(emailController.text.trim());

      if (response.success) {
        emailSent.value = true;
        Get.snackbar(
          'Success',
          'Password reset instructions have been sent to your email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 3),
        );
        
        // Clear the email field
        emailController.clear();
        
        // Wait for snackbar to be visible before going back
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
} 