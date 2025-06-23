import 'package:get/get.dart';

class AccountController extends GetxController {
  var isLoginPage = true.obs;
  var isLoggedIn = false.obs;

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
