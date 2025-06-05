import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';

class RegisterController extends GetxController {
  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  var isPasswordVisible = false.obs;
  var agreeToTerms = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Methods
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleAgreeToTerms(bool? value) {
    agreeToTerms.value = value ?? false;
  }

  void onTermsAndConditionsTap() {
    // Show terms and conditions
    // TODO: Implement terms and conditions display
  }

  void onSignInTap() {
    // Navigate to login page
    final accountController = Get.find<AccountController>();
    accountController.showLoginPage();
  }

  Future<void> handleRegister() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      // Validation failed - fields are empty
      return;
    }

    if (!agreeToTerms.value) {
      // Validation failed - terms not agreed
      return;
    }

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Registration successful - could navigate to login or dashboard
    // TODO: Implement post-registration flow
  }
}
