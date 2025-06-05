import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';

class LoginController extends GetxController {
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
      // Validation failed - fields are empty
      return;
    }

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Show dashboard in Account tab
    final accountController = Get.find<AccountController>();
    accountController.showDashboard();
  }
}
