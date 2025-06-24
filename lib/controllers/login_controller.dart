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
    // Handle forgot password
    // TODO: Implement forgot password functionality
  }

  void onSignUpTap() {
    // Navigate to register page
    final accountController = Get.find<AccountController>();
    accountController.showRegisterPage();
  }

  Future<void> handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = LoginRequest(
        email: emailController.text,
        password: passwordController.text,
      );

      final response = await _authService.login(request);

      if (response.success && response.data != null) {
        // Show dashboard in Account tab
        final accountController = Get.find<AccountController>();
        accountController.showDashboard();
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during login',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
