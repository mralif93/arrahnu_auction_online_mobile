import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends GetxController {
  final AuthService _authService = AuthService();
  final StorageService _storageService = Get.find<StorageService>();

  // Observable variables
  final isLoading = false.obs;
  final user = Rx<User?>(null);
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  // Check authentication status on app start
  Future<void> _checkAuthStatus() async {
    isLoading.value = true;
    
    try {
      // Check if user is authenticated
      final authenticated = _authService.isAuthenticated();
      isLoggedIn.value = authenticated;
      
      if (authenticated) {
        // Load user from storage
        final storedUser = _storageService.getUser();
        if (storedUser != null) {
          user.value = storedUser;
          debugPrint('🔍 AuthProvider: User loaded from storage: ${storedUser.fullName}');
        } else {
          debugPrint('🚨 AuthProvider: No user data found in storage');
          // Clear authentication if no user data
          await logout();
        }
      }
    } catch (e) {
      debugPrint('🚨 AuthProvider: Error checking auth status: $e');
      await logout();
    } finally {
      isLoading.value = false;
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    
    try {
      final result = await _authService.login(email, password);
      
      if (result.success && result.user != null) {
        user.value = result.user;
        isLoggedIn.value = true;
        debugPrint('🔍 AuthProvider: Login successful for ${result.user!.fullName}');
        return true;
      } else {
        debugPrint('🚨 AuthProvider: Login failed: ${result.error}');
        return false;
      }
    } catch (e) {
      debugPrint('🚨 AuthProvider: Login error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Register method
  Future<bool> register(String fullName, String username, String email, String password, String passwordConfirmation) async {
    isLoading.value = true;
    
    try {
      // Create register request (you'll need to import this from auth_models.dart)
      // For now, using a simple approach
      final result = await _authService.register(RegisterRequest(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ));
      
      if (result.success) {
        debugPrint('🔍 AuthProvider: Registration successful');
        return true;
      } else {
        debugPrint('🚨 AuthProvider: Registration failed: ${result.error}');
        return false;
      }
    } catch (e) {
      debugPrint('🚨 AuthProvider: Registration error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    isLoading.value = true;
    
    try {
      await _authService.logout();
      user.value = null;
      isLoggedIn.value = false;
      debugPrint('🔍 AuthProvider: Logout successful');
    } catch (e) {
      debugPrint('🚨 AuthProvider: Logout error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Placeholder methods for removed functionality
  Future<bool> forgotPassword(String email) async {
    debugPrint('🔍 AuthProvider: forgotPassword not implemented');
    return false;
  }

  Future<bool> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    debugPrint('🔍 AuthProvider: resetPassword not implemented');
    return false;
  }

  Future<void> refreshUser() async {
    debugPrint('🔍 AuthProvider: refreshUser not implemented');
  }
} 