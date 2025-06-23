import 'package:get/get.dart';
import '../services/storage_service.dart';

class AccountController extends GetxController {
  var isLoginPage = true.obs;
  var isLoggedIn = false.obs;

  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final token = await _storageService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }

  void showLoginPage() {
    isLoginPage.value = true;
    isLoggedIn.value = false;
  }

  void showRegisterPage() {
    isLoginPage.value = false;
    isLoggedIn.value = false;
  }

  void showDashboard() {
    isLoggedIn.value = true;
  }

  void logout() {
    isLoggedIn.value = false;
    isLoginPage.value = true;
  }

  void togglePage() {
    isLoginPage.value = !isLoginPage.value;
  }
}
