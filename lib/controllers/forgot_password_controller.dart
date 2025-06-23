import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends GetxController {
  // Text controllers
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final currentStep = 0.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  Future<void> handleForgotPassword() async {
    if (isLoading.value) return;
    
    final email = emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Success
      Get.snackbar(
        'Success',
        'Password reset instructions sent to $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate back to login after delay
      await Future.delayed(const Duration(seconds: 1));
      onBackToLoginTap();
    } catch (e) {
      errorMessage.value = 'Failed to send password reset email';
      Get.snackbar(
        'Error',
        'Failed to send password reset email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> sendResetCode() async {
    final email = emailController.text.trim();
    
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      successMessage.value = 'Reset code sent to $email';
      currentStep.value = 1;
    } catch (e) {
      errorMessage.value = 'Failed to send reset code';
      print('Error sending reset code: $e');
    }
    
    isLoading.value = false;
  }
  
  Future<void> verifyCode() async {
    final code = codeController.text.trim();
    
    if (code.isEmpty) {
      errorMessage.value = 'Please enter the reset code';
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (code == '123456') { // Dummy verification code
        successMessage.value = 'Code verified successfully';
        currentStep.value = 2;
      } else {
        errorMessage.value = 'Invalid reset code';
      }
    } catch (e) {
      errorMessage.value = 'Failed to verify code';
      print('Error verifying code: $e');
    }
    
    isLoading.value = false;
  }
  
  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      errorMessage.value = 'Please enter both passwords';
      return;
    }
    
    if (newPassword != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      return;
    }
    
    if (newPassword.length < 8) {
      errorMessage.value = 'Password must be at least 8 characters long';
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      successMessage.value = 'Password reset successfully';
      
      // Navigate to login after short delay
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = 'Failed to reset password';
      print('Error resetting password: $e');
    }
    
    isLoading.value = false;
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
  
  void onBackToLoginTap() {
    Get.back();
  }
  
  void goBack() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }
} 