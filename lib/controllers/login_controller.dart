import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_controller.dart';
import '../services/storage_service.dart';

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

  @override
  void onInit() {
    super.onInit();
    // Load remember me state
    rememberMe.value = _storageService.getRememberMe();
    
    // Load saved email if remember me is enabled
    if (rememberMe.value) {
      final userData = _storageService.getUser();
      if (userData != null && userData['email'] != null) {
        emailController.text = userData['email'];
      }
    }
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
    _storageService.saveRememberMe(rememberMe.value);
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
    if (isLoading.value) return;
    
    final email = emailController.text.trim();
    final password = passwordController.text;
    
    // Validate input
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      return;
    }
    
    if (password.isEmpty || password.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Dummy successful login
      final userData = {
        'id': '12345',
        'email': email,
        'fullName': 'John Doe',
        'isEmailVerified': true,
      };
      
      // Save user data
      await _storageService.saveUser(userData);
      
      // Navigate to home
      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = 'Invalid email or password';
      Get.snackbar(
        'Error',
        'Invalid email or password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
