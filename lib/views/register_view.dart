import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(child: _buildResponsiveLayout(context)),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),

          // Logo/Icon Section
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFE8000), Color(0xFFFF9500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFE8000).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.person_add, size: 45, color: Colors.white),
          ),

          const SizedBox(height: 20),

          // Welcome Text
          Text(
            "Create Account",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Join Ar-Rahnu Auction today and start bidding on amazing items",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // Register Form
          _buildRegisterForm(),

          const SizedBox(height: 16),

          // Terms and Conditions
          _buildTermsSection(),

          const SizedBox(height: 20),

          // Register Button
          _buildRegisterButton(),

          const SizedBox(height: 24),

          // Sign In Link
          _buildSignInLink(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, double screenWidth) {
    final tabletPadding = _getTabletPadding(screenWidth);
    final maxWidth = _getMaxContentWidth(screenWidth);

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.all(tabletPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenWidth >= 1024 ? 40 : 30),

            // Logo/Icon Section - Tablet optimized
            _buildTabletLogo(screenWidth),

            SizedBox(height: screenWidth >= 1024 ? 32 : 28),

            // Welcome Text - Tablet optimized
            Text(
              "Create Account",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: _getTabletTitleFontSize(screenWidth),
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: screenWidth >= 1024 ? 12 : 10),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth >= 1024 ? 48 : 40,
              ),
              child: Text(
                "Join Ar-Rahnu Auction today and start bidding on amazing items",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: _getTabletSubtitleFontSize(screenWidth),
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: screenWidth >= 1024 ? 32 : 28),

            // Register Form - Tablet optimized
            _buildTabletRegisterForm(screenWidth),

            SizedBox(height: screenWidth >= 1024 ? 20 : 18),

            // Terms and Conditions - Tablet optimized
            _buildTabletTermsSection(screenWidth),

            SizedBox(height: screenWidth >= 1024 ? 28 : 24),

            // Register Button - Tablet optimized
            _buildTabletRegisterButton(screenWidth),

            SizedBox(height: screenWidth >= 1024 ? 32 : 28),

            // Sign In Link - Tablet optimized
            _buildTabletSignInLink(screenWidth),

            SizedBox(height: screenWidth >= 1024 ? 28 : 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        Text(
          "Full Name",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.nameController,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: "Enter your full name",
              hintStyle: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: Colors.grey.shade600,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFE8000),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Email Field
        Text(
          "Email Address",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: "Enter your email address",
              hintStyle: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.grey.shade600,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFE8000),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Password Field
        Text(
          "Password",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: "Create a strong password",
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey.shade600,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFFE8000),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: controller.agreeToTerms.value,
                onChanged: controller.toggleAgreeToTerms,
                activeColor: const Color(0xFFFE8000),
                checkColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade400, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Text(
                  "I agree to the ",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: controller.onTermsAndConditionsTap,
                  child: const Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFFFE8000),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFFE8000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.handleRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFE8000),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  "Create Account",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: controller.onSignInTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: const Text(
                "Sign In",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xFFFE8000),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFFE8000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tablet responsive helper methods
  double _getTabletPadding(double screenWidth) {
    if (screenWidth >= 1194) return 48.0; // 14" tablets
    if (screenWidth >= 1112) return 44.0; // 13" tablets
    if (screenWidth >= 1024) return 40.0; // 12" tablets
    if (screenWidth >= 834) return 36.0; // 11" tablets
    return 32.0; // 10" tablets
  }

  double _getMaxContentWidth(double screenWidth) {
    if (screenWidth >= 1194) return 600.0; // 14" tablets
    if (screenWidth >= 1112) return 580.0; // 13" tablets
    if (screenWidth >= 1024) return 560.0; // 12" tablets
    if (screenWidth >= 834) return 520.0; // 11" tablets
    return 480.0; // 10" tablets
  }

  double _getTabletTitleFontSize(double screenWidth) {
    if (screenWidth >= 1194) return 36.0; // 14" tablets
    if (screenWidth >= 1112) return 34.0; // 13" tablets
    if (screenWidth >= 1024) return 32.0; // 12" tablets
    if (screenWidth >= 834) return 30.0; // 11" tablets
    return 28.0; // 10" tablets
  }

  double _getTabletSubtitleFontSize(double screenWidth) {
    if (screenWidth >= 1194) return 20.0; // 14" tablets
    if (screenWidth >= 1112) return 19.0; // 13" tablets
    if (screenWidth >= 1024) return 18.0; // 12" tablets
    if (screenWidth >= 834) return 17.0; // 11" tablets
    return 16.0; // 10" tablets
  }

  Widget _buildTabletLogo(double screenWidth) {
    final logoSize = _getTabletLogoSize(screenWidth);
    final iconSize = logoSize * 0.45;
    final borderRadius = logoSize * 0.25;

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFE8000), Color(0xFFFF9500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFE8000).withValues(alpha: 0.3),
            blurRadius: screenWidth >= 1024 ? 20 : 15,
            offset: Offset(0, screenWidth >= 1024 ? 8 : 5),
          ),
        ],
      ),
      child: Icon(Icons.person_add, size: iconSize, color: Colors.white),
    );
  }

  double _getTabletLogoSize(double screenWidth) {
    if (screenWidth >= 1194) return 140.0; // 14" tablets
    if (screenWidth >= 1112) return 130.0; // 13" tablets
    if (screenWidth >= 1024) return 120.0; // 12" tablets
    if (screenWidth >= 834) return 110.0; // 11" tablets
    return 100.0; // 10" tablets
  }

  Widget _buildTabletRegisterForm(double screenWidth) {
    final fieldSpacing = screenWidth >= 1024 ? 20.0 : 18.0;
    final fontSize = screenWidth >= 1024 ? 18.0 : 16.0;
    final labelFontSize = screenWidth >= 1024 ? 18.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        Text(
          "Full Name",
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
            controller: controller.nameController,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: "Enter your full name",
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontFamily: 'Montserrat',
                fontSize: fontSize,
              ),
              prefixIcon: Icon(
                Icons.person_outline,
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
                horizontal: screenWidth >= 1024 ? 20 : 16,
                vertical: screenWidth >= 1024 ? 18 : 16,
              ),
            ),
          ),
        ),
        SizedBox(height: fieldSpacing),

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
                horizontal: screenWidth >= 1024 ? 20 : 16,
                vertical: screenWidth >= 1024 ? 18 : 16,
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
                hintText: "Create a strong password",
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
                  horizontal: screenWidth >= 1024 ? 20 : 16,
                  vertical: screenWidth >= 1024 ? 18 : 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletTermsSection(double screenWidth) {
    final fontSize = screenWidth >= 1024 ? 16.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenWidth >= 1024 ? 6 : 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => Transform.scale(
              scale: screenWidth >= 1024 ? 1.2 : 1.1,
              child: Checkbox(
                value: controller.agreeToTerms.value,
                onChanged: controller.toggleAgreeToTerms,
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
          Expanded(
            child: Wrap(
              children: [
                Text(
                  "I agree to the ",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey.shade700,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: controller.onTermsAndConditionsTap,
                  child: Text(
                    "Terms & Conditions",
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletRegisterButton(double screenWidth) {
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
          onPressed: controller.isLoading.value
              ? null
              : controller.handleRegister,
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
                  "Create Account",
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

  Widget _buildTabletSignInLink(double screenWidth) {
    final fontSize = screenWidth >= 1024 ? 18.0 : 16.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenWidth >= 1024 ? 10 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey.shade600,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: controller.onSignInTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth >= 1024 ? 6 : 4,
                vertical: screenWidth >= 1024 ? 3 : 2,
              ),
              child: Text(
                "Sign In",
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
