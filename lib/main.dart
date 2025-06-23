import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/login_controller.dart';
import 'controllers/register_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/navigation_controller.dart';
import 'controllers/account_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/forgot_password_controller.dart';
import 'controllers/email_verification_controller.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';
import 'views/dashboard_view.dart';
import 'views/main_navigation_view.dart';
import 'views/account_view.dart';
import 'views/account_collaterals_view.dart';
import 'views/collateral_detail_view.dart';
import 'views/branch_accounts_view.dart';
import 'pages/email_verification_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/profile_page.dart';
import 'pages/update_profile_page.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ar-Rahnu Auction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFE8000),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFE8000),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFE8000),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFE8000),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      themeMode: ThemeMode.system,
      defaultTransition: Transition.fadeIn,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MainNavigationView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<NavigationController>(() => NavigationController());
            Get.lazyPut<HomeController>(() => HomeController());
            Get.lazyPut<DashboardController>(() => DashboardController());
            Get.lazyPut<AccountController>(() => AccountController());
          }),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<LoginController>(() => LoginController());
          }),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<RegisterController>(() => RegisterController());
          }),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const DashboardView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<DashboardController>(() => DashboardController());
          }),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<HomeController>(() => HomeController());
          }),
        ),
        GetPage(
          name: '/account',
          page: () => const AccountView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AccountController>(() => AccountController());
          }),
        ),
        GetPage(
          name: '/account-collaterals',
          page: () {
            final args = Get.arguments as Map<String, dynamic>? ?? {};
            return AccountCollateralsView(
              branchName: args['branchName'] ?? '',
              accountNumber: args['accountNumber'] ?? '',
              accountData: args['accountData'] ?? {},
            );
          },
          binding: BindingsBuilder(() {
            Get.lazyPut<AccountController>(() => AccountController());
          }),
        ),
        GetPage(
          name: '/collateral-detail',
          page: () {
            final args = Get.arguments as Map<String, dynamic>? ?? {};
            return CollateralDetailView(
              branchName: args['branchName'] ?? '',
              accountNumber: args['accountNumber'] ?? '',
              accountName: args['accountName'] ?? '',
              collateral: args['collateral'] ?? {},
            );
          },
          binding: BindingsBuilder(() {
            Get.lazyPut<AccountController>(() => AccountController());
          }),
        ),
        GetPage(
          name: '/branch-accounts',
          page: () {
            final args = Get.arguments as Map<String, dynamic>? ?? {};
            return BranchAccountsView(
              branchName: args['branchName'] ?? '',
            );
          },
          binding: BindingsBuilder(() {
            Get.lazyPut<AccountController>(() => AccountController());
          }),
        ),
        GetPage(
          name: '/email-verification',
          page: () => const EmailVerificationPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<EmailVerificationController>(() => EmailVerificationController());
          }),
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
          }),
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfilePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ProfileController>(() => ProfileController());
          }),
        ),
        GetPage(
          name: '/update-profile',
          page: () => const UpdateProfilePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ProfileController>(() => ProfileController());
          }),
        ),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put<StorageService>(StorageService());
      }),
    );
  }
}

// VelocityX demo removed - using standard Flutter navigation
