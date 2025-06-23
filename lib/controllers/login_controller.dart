import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/user.dart';



class LoginController extends GetxController {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Services
  final StorageService _storageService = Get.find<StorageService>();
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // Load remember me preference
    rememberMe.value = _storageService.getRememberMe();
  }

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
    _storageService.setRememberMe(rememberMe.value);
  }

  void onForgotPasswordTap() {
    // Navigate to forgot password page and pass the current email if entered
    Get.toNamed('/forgot-password', arguments: {
      'email': emailController.text,
    });
  }

  void onSignUpTap() {
    // Navigate to register page
    final accountController = Get.find<AccountController>();
    accountController.showRegisterPage();
  }

  Future<void> handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _authService.login(
        emailController.text,
        passwordController.text,
      );

      if (result.success && result.user != null) {
        // Login success
        await _completeLogin(result.user!, result.token);
      } else {
        final error = result.error ?? 'Login failed';
        errorMessage.value = error;
        
        // Handle email verification needed
        if (result.needsEmailVerification) {
          _navigateToEmailVerification();
        } else {
          // Show snackbar for other errors
          Get.snackbar(
            'Login Failed',
            error,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
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

  void _navigateToEmailVerification() {
    Get.toNamed('/email-verification', arguments: {
      'email': emailController.text,
    });
  }

  Future<void> _completeLogin(User user, String? token) async {
    // Save user data (token is already saved by AuthService)
    await _storageService.saveUser(user);
    
    // Save token if provided (for backwards compatibility with storage service)
    if (token != null) {
      await _storageService.saveAuthToken(token);
    }

    // Show success message
    Get.snackbar(
      'Login Successful',
      'Welcome back! You have been logged in successfully.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Show dashboard in Account tab
    final accountController = Get.find<AccountController>();
    accountController.showDashboard();
  }
}
