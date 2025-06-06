import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_padding.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
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
                    Icons.person_add,
                    size: ResponsivePadding.isTabletSize(screenWidth) ? 50 : 40,
                    color: AppColors.textWhite,
                  ),
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Welcome Text
                Text(
                  "Create Account",
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth)),

                Text(
                  "Join Ar-Rahnu Auction today",
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth) * 1.5),

                // Register Form
                _buildRegisterForm(screenWidth),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "I agree to the ",
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          TextButton(
                            onPressed: () {
                              _showMaterialFeedback(
                                "Terms & Conditions clicked!",
                              );
                            },
                            child: Text(
                              "Terms & Conditions",
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: AppTypography.semiBold,
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth)),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
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
                            "Create Account",
                            style: AppTypography.buttonText.copyWith(
                              fontSize: AppTypography.lg,
                              fontWeight: AppTypography.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),

                SizedBox(height: ResponsivePadding.getSectionSpacing(screenWidth) * 1.5),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextButton(
                      onPressed: () {
                        _showMaterialFeedback("Navigate to Sign In!");
                      },
                      child: const Text(
                        "Sign In",
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

  Widget _buildRegisterForm(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        Text(
          "Full Name",
          style: AppTypography.titleSmall.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ResponsivePadding.getSmallSpacing(screenWidth) / 2),
        TextFormField(
          controller: _nameController,
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: "Enter your full name",
            prefixIcon: Icon(Icons.person_outline, color: AppColors.textLight),
            contentPadding: ResponsivePadding.getInputContentPadding(screenWidth),
          ),
        ),

        SizedBox(height: ResponsivePadding.getFormFieldSpacing(screenWidth)),

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
            hintText: "Create a strong password",
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

  void _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showMaterialFeedback("Please fill all fields!");
      return;
    }

    if (!_agreeToTerms) {
      _showMaterialFeedback("Please agree to terms & conditions!");
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

    _showMaterialFeedback(
      "Account created successfully! Welcome to Ar-Rahnu Auction!",
    );
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
