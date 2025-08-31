import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import '../../services/auth.dart';

import '../../core/app_export.dart';
import './widgets/google_oauth_button.dart';
import './widgets/registration_form.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAccepted = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  final AuthService _auth = AuthService(); 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _onTermsChanged(bool? value) {
    setState(() {
      _isTermsAccepted = value ?? false;
    });
  }

  void _onTermsTap() {
    // Open Terms of Service in in-app browser
    _showInfoDialog(
      'Terms of Service',
      'By using SkinKair AI, you agree to our terms and conditions. This includes responsible use of our AI-powered skincare recommendations and voice interaction features.',
    );
  }

  void _onPrivacyTap() {
    // Open Privacy Policy in in-app browser
    _showInfoDialog(
      'Privacy Policy',
      'We protect your privacy and skincare data. Your voice interactions and personal information are encrypted and used only to provide personalized skincare recommendations.',
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true && _isTermsAccepted;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid()) {
      if (!_isTermsAccepted) {
        _showErrorMessage(
            'Please accept the Terms of Service and Privacy Policy');
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _auth.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (user == null) {
        _showErrorMessage('Registration failed. Please try again.');
        return;
      }
      await _auth.sendOtp(email: _emailController.text.trim());

      _showSuccessMessage(
          'Account created successfully! Welcome to SkinKair.ai!');
      HapticFeedback.lightImpact();

      await Future.delayed(const Duration(milliseconds: 1500));

      Navigator.pushReplacementNamed(context, '/verification');
    } catch (e) {
      _showErrorMessage('Registration failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignUp() async {

    setState(() => _isGoogleLoading = true);

    try {
      final user = await _auth.signInWithGoogle();
      if (user == null) {
        _showErrorMessage('Google Sign-In failed.');
        return;
      }

      _showSuccessMessage('Welcome, ${user.email}!');

      // 15 sec difference logic
      final isNewUser = _auth.isNewUser;

      if (isNewUser) {
        // New User -> Onboarding
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      } else {
        // Existing User -> Home
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    
    } catch (e) {
      _showErrorMessage('Google Sign-In failed: $e');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: AppTheme.lightTheme.colorScheme.onError,
      fontSize: 14,
    );
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor:
          AppTheme.getSemanticColor(type: 'success', isLight: true),
      textColor: AppTheme.lightTheme.colorScheme.surface,
      fontSize: 14,
    );
  }

  void _navigateBack() {
    // Clear sensitive information before navigating back
    _passwordController.clear();
    _confirmPasswordController.clear();
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: _navigateBack,
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            size: 6.w,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // Header Section
              Text(
                'Create Account',
                style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                'Join SkinKair AI for personalized skincare recommendations powered by voice-first AI technology.',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 4.h),

              // Registration Form
              RegistrationForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                isPasswordVisible: _isPasswordVisible,
                isConfirmPasswordVisible: _isConfirmPasswordVisible,
                isTermsAccepted: _isTermsAccepted,
                togglePasswordVisibility: _togglePasswordVisibility,
                toggleConfirmPasswordVisibility:
                    _toggleConfirmPasswordVisibility,
                onTermsChanged: _onTermsChanged,
                onTermsTap: _onTermsTap,
                onPrivacyTap: _onPrivacyTap,
              ),

              SizedBox(height: 4.h),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: (_isLoading || _isGoogleLoading)
                      ? null
                      : _handleRegistration,
                  child: _isLoading
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Create Account',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 3.h),

              // Divider with "OR"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'OR',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Google OAuth Button
              GoogleOAuthButton(
                onPressed: _handleGoogleSignUp,
                isLoading: _isGoogleLoading,
              ),

              SizedBox(height: 4.h),

              // Login Link
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, '/login-screen'),
                          child: Text(
                            'Sign In',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
