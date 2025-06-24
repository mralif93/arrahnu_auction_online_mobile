import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import 'auth/login_view.dart';
import 'auth/register_view.dart';
import 'dashboard_view.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoggedIn.value) {
        return const DashboardView();
      } else if (controller.isLoginPage.value) {
        return const LoginView();
      } else {
        return const RegisterView();
      }
    });
  }
}
