import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';
import '../services/auth_service.dart';
import '../models/auth/login_request.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    _authService.dispose();
    super.onClose();
  }

  // Methods
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void onForgotPasswordTap() {
    Get.toNamed('/forgot-password');
  }

  void onSignUpTap() {
    // Navigate to register page
    final accountController = Get.find<AccountController>();
    accountController.showRegisterPage();
  }

  Future<void> handleLogin() async {
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

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
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
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final response = await _authService.login(request);

      if (response.success && response.data != null) {
        // Verify user status
        if (response.data!.user.status.toLowerCase() != 'active') {
          Get.snackbar(
            'Error',
            'Your account is not active. Please contact support.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
          );
          return;
        }

        // Store token if remember me is checked
        if (rememberMe.value) {
          // TODO: Implement secure token storage
          // final token = '${response.data!.token_type} ${response.data!.token}';
        }

        // Clear form
        emailController.clear();
        passwordController.clear();

        // Show success message
        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 2),
        );

        // Wait for snackbar to be visible before navigation
        await Future.delayed(const Duration(milliseconds: 500));

        // Show dashboard in Account tab
        final accountController = Get.find<AccountController>();
        accountController.showDashboard();
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
