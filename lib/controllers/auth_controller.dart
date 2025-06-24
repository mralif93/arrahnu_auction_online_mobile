import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/auth/login_request.dart';
import '../models/auth/auth_response.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;
  final Rx<AuthResponse?> authResponse = Rx<AuthResponse?>(null);
  final RxBool isLoggedIn = false.obs;
  final Rx<String?> token = Rx<String?>(null);

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      
      final request = LoginRequest(
        email: email,
        password: password,
      );

      final response = await _authService.login(request);
      authResponse.value = response;

      if (response.success && response.data != null) {
        isLoggedIn.value = true;
        token.value = response.data!.token;
        // Navigate to home or dashboard
        Get.offAllNamed('/home');
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

  void logout() {
    isLoggedIn.value = false;
    token.value = null;
    authResponse.value = null;
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    _authService.dispose();
    super.onClose();
  }
} 