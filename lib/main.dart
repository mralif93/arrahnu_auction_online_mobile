import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/main_navigation_view.dart';
import 'controllers/navigation_controller.dart';
import 'controllers/account_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/register_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ar-Rahnu Auction',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFE8000),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFE8000),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Tailwind CSS-like typography using custom Montserrat font
        fontFamily: 'Montserrat',
        textTheme: ThemeData.light().textTheme.copyWith(
          // Tailwind text-xs (12px)
          bodySmall: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          // Tailwind text-sm (14px)
          bodyMedium: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          // Tailwind text-base (16px)
          bodyLarge: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          // Tailwind text-lg (18px)
          titleMedium: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          // Tailwind text-xl (20px)
          titleLarge: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
          // Tailwind text-2xl (24px)
          headlineSmall: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
          // Tailwind text-3xl (30px)
          headlineMedium: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
          // Tailwind text-4xl (36px)
          headlineLarge: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ),
        // Input decoration theme with Tailwind-like styling
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFFE8000), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          hintStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
      home: const MainNavigationView(),
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(NavigationController());
        Get.put(AccountController());
        Get.put(HomeController());
        Get.put(LoginController());
        Get.put(RegisterController());
        Get.put(DashboardController());
      }),
    );
  }
}

// VelocityX demo removed - using standard Flutter navigation
