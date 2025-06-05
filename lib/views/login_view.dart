import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(child: _buildResponsiveLayout(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = _isTabletSize(screenWidth);

    if (isTablet) {
      return _buildTabletLayout(context, screenWidth);
    } else {
      return _buildMobileLayout();
    }
  }

  bool _isTabletSize(double screenWidth) {
    // Tablet sizes: 10" (~768px), 11" (~834px), 12" (~1024px), 13" (~1112px), 14" (~1194px)
    return screenWidth >= 768;
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Sticky Logo Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 40, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/images/logo/001.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.account_balance,
                        size: 48,
                        color: const Color(0xFFFE8000),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Compact Welcome Text
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Sign in to continue",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Compact Login Form
                  _buildCompactLoginForm(),

                  const SizedBox(height: 16),

                  // Compact Login Button
                  _buildCompactLoginButton(),

                  const SizedBox(height: 12),

                  // Compact Remember Me & Forgot Password
                  _buildCompactRememberMeSection(),

                  const SizedBox(height: 16),

                  // Compact Sign Up Link
                  _buildCompactSignUpLink(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(
        8,
      ), // Reduced from responsive padding to match home page
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: screenWidth >= 1024 ? 10 : 8,
          ), // Reduced top spacing to match home page
          // Logo Image Section - 50% Width for Tablets
          _buildTabletLogo(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 16 : 14),

          // Welcome Text - Tablet optimized
          Text(
            "Welcome Back!",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: _getTabletTitleFontSize(screenWidth),
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenWidth >= 1024 ? 8 : 6),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth >= 1024 ? 32 : 28,
            ),
            child: Text(
              "Sign in to your account",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: _getTabletSubtitleFontSize(screenWidth),
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: screenWidth >= 1024 ? 20 : 18),

          // Login Form - Tablet optimized
          _buildTabletLoginForm(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 14 : 12),

          // Remember Me & Forgot Password - Tablet optimized
          _buildTabletRememberMeSection(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 18 : 16),

          // Login Button - Tablet optimized
          _buildTabletLoginButton(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 18 : 16),

          // Sign Up Link - Tablet optimized
          _buildTabletSignUpLink(screenWidth),

          SizedBox(height: screenWidth >= 1024 ? 14 : 12),
        ],
      ),
    );
  }

  Widget _buildCompactLoginForm() {
    return Column(
      children: [
        // Compact Email Field
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: "Email address",
            hintStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: const Color(0xFFFE8000),
              size: 18,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFFE8000),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Compact Password Field
        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: const Color(0xFFFE8000),
                size: 18,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFFE8000),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactRememberMeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(
              () => Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: controller.toggleRememberMe,
                  activeColor: const Color(0xFFFE8000),
                  checkColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade400, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Remember me",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey.shade700,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: controller.onForgotPasswordTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color(0xFFFE8000),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLoginButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFE8000),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          shadowColor: const Color(0xFFFE8000).withValues(alpha: 0.3),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Sign In",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildCompactSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: controller.onSignUpTap,
          child: const Text(
            "Sign Up",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xFFFE8000),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFFFE8000),
            ),
          ),
        ),
      ],
    );
  }

  // Tablet responsive helper methods

  double _getTabletTitleFontSize(double screenWidth) {
    if (screenWidth >= 1194) return 26.0; // 14" tablets
    if (screenWidth >= 1112) return 24.0; // 13" tablets
    if (screenWidth >= 1024) return 22.0; // 12" tablets
    if (screenWidth >= 834) return 21.0; // 11" tablets
    return 20.0; // 10" tablets
  }

  double _getTabletSubtitleFontSize(double screenWidth) {
    if (screenWidth >= 1194) return 15.0; // 14" tablets
    if (screenWidth >= 1112) return 14.0; // 13" tablets
    if (screenWidth >= 1024) return 13.0; // 12" tablets
    if (screenWidth >= 834) return 13.0; // 11" tablets
    return 12.0; // 10" tablets
  }

  Widget _buildTabletLogo(double screenWidth) {
    final logoHeight = _getTabletLogoHeight(screenWidth);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth >= 1024 ? 24 : 20,
        vertical: screenWidth >= 1024 ? 12 : 10,
      ),
      child: Center(
        child: Container(
          height: logoHeight,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth >= 1024 ? 32 : 24,
          ),
          child: Image.asset(
            'assets/images/logo/001.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: logoHeight,
                padding: EdgeInsets.all(screenWidth >= 1024 ? 20 : 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFE8000).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    screenWidth >= 1024 ? 16 : 12,
                  ),
                ),
                child: Icon(
                  Icons.account_balance,
                  size: logoHeight * 0.6,
                  color: const Color(0xFFFE8000),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _getTabletLogoHeight(double screenWidth) {
    if (screenWidth >= 1194) {
      return 100.0; // 14" tablets - Optimized for card-less design
    }
    if (screenWidth >= 1112) return 95.0; // 13" tablets
    if (screenWidth >= 1024) return 90.0; // 12" tablets
    if (screenWidth >= 834) return 85.0; // 11" tablets
    return 80.0; // 10" tablets
  }

  Widget _buildTabletLoginForm(double screenWidth) {
    final fieldSpacing = screenWidth >= 1024 ? 20.0 : 18.0;
    final fontSize = screenWidth >= 1024 ? 18.0 : 16.0;
    final labelFontSize = screenWidth >= 1024 ? 18.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        Text(
          "Email Address",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontSize: labelFontSize,
          ),
        ),
        SizedBox(height: screenWidth >= 1024 ? 10 : 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth >= 1024 ? 16 : 12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: screenWidth >= 1024 ? 12 : 8,
                offset: Offset(0, screenWidth >= 1024 ? 3 : 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.emailController,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: "Enter your email address",
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontFamily: 'Montserrat',
                fontSize: fontSize,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: const Color(0xFFFE8000),
                size: screenWidth >= 1024 ? 24 : 22,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  screenWidth >= 1024 ? 16 : 12,
                ),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  screenWidth >= 1024 ? 16 : 12,
                ),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  screenWidth >= 1024 ? 16 : 12,
                ),
                borderSide: const BorderSide(
                  color: Color(0xFFFE8000),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth >= 1024 ? 24 : 20,
                vertical: screenWidth >= 1024 ? 22 : 20,
              ),
            ),
          ),
        ),
        SizedBox(height: fieldSpacing),

        // Password Field
        Text(
          "Password",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontSize: labelFontSize,
          ),
        ),
        SizedBox(height: screenWidth >= 1024 ? 10 : 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth >= 1024 ? 16 : 12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: screenWidth >= 1024 ? 12 : 8,
                offset: Offset(0, screenWidth >= 1024 ? 3 : 2),
              ),
            ],
          ),
          child: Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontFamily: 'Montserrat',
                  fontSize: fontSize,
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: const Color(0xFFFE8000),
                  size: screenWidth >= 1024 ? 24 : 22,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    !controller.isPasswordVisible.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade600,
                    size: screenWidth >= 1024 ? 24 : 22,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    screenWidth >= 1024 ? 16 : 12,
                  ),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    screenWidth >= 1024 ? 16 : 12,
                  ),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    screenWidth >= 1024 ? 16 : 12,
                  ),
                  borderSide: const BorderSide(
                    color: Color(0xFFFE8000),
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth >= 1024 ? 24 : 20,
                  vertical: screenWidth >= 1024 ? 22 : 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletRememberMeSection(double screenWidth) {
    final fontSize = screenWidth >= 1024 ? 16.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenWidth >= 1024 ? 6 : 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Transform.scale(
                  scale: screenWidth >= 1024 ? 1.2 : 1.1,
                  child: Checkbox(
                    value: controller.rememberMe.value,
                    onChanged: controller.toggleRememberMe,
                    activeColor: const Color(0xFFFE8000),
                    checkColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade400, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        screenWidth >= 1024 ? 10 : 8,
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              SizedBox(width: screenWidth >= 1024 ? 10 : 8),
              Text(
                "Remember me",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey.shade700,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: controller.onForgotPasswordTap,
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: const Color(0xFFFE8000),
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLoginButton(double screenWidth) {
    final buttonHeight = screenWidth >= 1024 ? 56.0 : 52.0;
    final fontSize = screenWidth >= 1024 ? 20.0 : 18.0;
    final borderRadius = screenWidth >= 1024 ? 16.0 : 12.0;

    return Container(
      width: double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.3),
            blurRadius: screenWidth >= 1024 ? 16 : 12,
            offset: Offset(0, screenWidth >= 1024 ? 6 : 4),
          ),
        ],
      ),
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFE8000),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: screenWidth >= 1024 ? 26 : 22,
                  height: screenWidth >= 1024 ? 26 : 22,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  "Sign In",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTabletSignUpLink(double screenWidth) {
    final fontSize = screenWidth >= 1024 ? 18.0 : 16.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenWidth >= 1024 ? 10 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey.shade600,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: controller.onSignUpTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth >= 1024 ? 6 : 4,
                vertical: screenWidth >= 1024 ? 3 : 2,
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: const Color(0xFFFE8000),
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFFFE8000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
