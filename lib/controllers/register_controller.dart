import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';
import '../services/auth_service.dart';
import '../models/auth_models.dart';

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

  // Services
  final AuthService _authService = AuthService();

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
      final request = RegisterRequest(
        fullName: fullNameController.text,
        username: fullNameController.text.toLowerCase().replaceAll(' ', ''),
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        phoneNumber: phoneController.text.isNotEmpty ? phoneController.text : null,
      );

      final result = await _authService.register(request);

      if (result.success && result.user != null) {
        
        // Show success message with proper instructions
        String successMessage = 'Account created successfully!';
        
        // Check if email verification is required
        if (result.user!.status == 'pending_approval') {
          successMessage = 'Account created successfully!\n\nPlease check your email to verify your account. After email verification, your account will be reviewed by our administrators.';
        }
        
        Get.dialog(
          AlertDialog(
            title: const Text('Registration Successful'),
            content: Text(successMessage),
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
      } else {
        final error = result.error ?? 'Registration failed';
        errorMessage.value = error;
        
        // Also show snackbar for immediate feedback
        Get.snackbar(
          'Registration Failed',
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      final error = 'An unexpected error occurred: $e';
      errorMessage.value = error;
      
      // Show snackbar for immediate feedback
      Get.snackbar(
        'Error',
        error,
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
