import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_padding.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppTheme.getPadding(
              horizontal: ResponsivePadding.getTabletPadding(screenWidth),
              vertical: ResponsivePadding.getTabletPadding(screenWidth),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth) * 2),

                // Logo/Icon Section
                Container(
                  width: ResponsivePadding.isTabletSize(screenWidth) ? 100 : 80,
                  height: ResponsivePadding.isTabletSize(screenWidth) ? 100 : 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppTheme.largeRadius,
                  ),
                  child: Icon(
                    Icons.diamond,
                    size: ResponsivePadding.isTabletSize(screenWidth) ? 50 : 40,
                    color: AppColors.textWhite,
                  ),
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Welcome Text
                Text(
                  "Welcome Back!",
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),

                Text(
                  "Sign in to your Ar-Rahnu account",
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth) * 1.5),

                // Login Form
                _buildLoginForm(screenWidth),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        Text(
                          "Remember me",
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _showMaterialFeedback("Forgot Password clicked!");
                      },
                      child: Text(
                        "Forgot Password?",
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTypography.semiBold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      padding: AppTheme.getPadding(vertical: 16, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.smallRadius,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.textWhite,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Sign In",
                            style: AppTypography.buttonText.copyWith(
                              fontSize: AppTypography.lg,
                              fontWeight: AppTypography.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: AppColors.borderLight),
                    ),
                    Padding(
                      padding: AppTheme.getPadding(horizontal: 16, vertical: 0),
                      child: Text(
                        "or continue with",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Container(height: 1, color: AppColors.borderLight),
                    ),
                  ],
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showMaterialFeedback("Google login clicked!");
                        },
                        icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                        label: Text(
                          "Google",
                          style: AppTypography.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: AppTheme.getPadding(vertical: 12, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.smallRadius,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsivePadding.getSmallSpacing(screenWidth)),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showMaterialFeedback("Apple login clicked!");
                        },
                        icon: Icon(Icons.apple, color: AppColors.textPrimary),
                        label: Text(
                          "Apple",
                          style: AppTypography.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: AppTheme.getPadding(vertical: 12, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.smallRadius,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextButton(
                      onPressed: () {
                        _showMaterialFeedback("Navigate to Register!");
                      },
                      child: const Text(
                        "Sign Up",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTypography.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        Text(
          "Email Address",
          style: AppTypography.titleSmall.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth) / 2),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: "Enter your email address",
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.textLight),
            contentPadding: ResponsivePadding.getInputContentPadding(screenWidth),
          ),
        ),

        SizedBox(height: ResponsivePadding.getFormFieldSpacing(screenWidth)),

        // Password Field
        Text(
          "Password",
          style: AppTypography.titleSmall.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth) / 2),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: "Enter your password",
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textLight),
            contentPadding: ResponsivePadding.getInputContentPadding(screenWidth),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textLight,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMaterialFeedback("Please fill all fields!");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _showMaterialFeedback("Login successful! Welcome to Ar-Rahnu Auction!");
  }

  void _showMaterialFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.smallRadius),
      ),
    );
  }
}
