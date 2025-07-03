import 'package:get/get.dart';
import '../views/auth/forgot_password_view.dart';
import '../views/auth/register_view.dart';
import '../controllers/forgot_password_controller.dart';
import '../controllers/register_controller.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/forgot-password',
      page: () => const ForgotPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: '/register',
      page: () => const RegisterView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RegisterController());
      }),
    ),
  ];
} 