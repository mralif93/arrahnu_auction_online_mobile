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
        } else {
          await logout();
        }
      }
    } catch (e) {
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
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
    } catch (e) {
      // Ignore logout errors - user is already logged out
    } finally {
      isLoading.value = false;
    }
  }

  // Placeholder methods for removed functionality
  Future<bool> forgotPassword(String email) async {
    return false;
  }

  Future<bool> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return false;
  }

  Future<void> refreshUser() async {
  }
} 