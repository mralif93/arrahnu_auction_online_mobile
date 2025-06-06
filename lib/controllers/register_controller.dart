import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';

class RegisterController extends GetxController {
  // Text editing controllers
  final fullNameController = TextEditingController();
  final icNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  final postcodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var agreeToTerms = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    icNumberController.dispose();
    emailController.dispose();
    phoneController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    address3Controller.dispose();
    postcodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Methods
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
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
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      // Validation failed - fields are empty
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      // Validation failed - passwords don't match
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
