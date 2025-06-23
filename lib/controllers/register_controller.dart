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
  var errorMessage = ''.obs;

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
    Get.dialog(
      AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'This is a dummy terms and conditions text. In a real app, this would contain the actual terms and conditions.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void onSignInTap() {
    // Navigate to login page
    final accountController = Get.find<AccountController>();
    accountController.showLoginPage();
  }

  Future<void> handleRegister() async {
    // Validation
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      errorMessage.value = 'Please fill all required fields';
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    if (passwordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return;
    }

    if (!agreeToTerms.value) {
      errorMessage.value = 'Please agree to terms and conditions';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      Get.dialog(
        AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text(
            'Account created successfully!\n\nPlease check your email to verify your account.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                // Navigate to login page
                final accountController = Get.find<AccountController>();
                accountController.showLoginPage();
                // Clear form
                _clearForm();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    fullNameController.clear();
    icNumberController.clear();
    emailController.clear();
    phoneController.clear();
    address1Controller.clear();
    address2Controller.clear();
    address3Controller.clear();
    postcodeController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    agreeToTerms.value = false;
    errorMessage.value = '';
  }
}
