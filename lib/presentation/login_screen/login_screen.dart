import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_logo_widget.dart';
import './widgets/google_oauth_button_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/signup_link_widget.dart';
import '../../services/auth.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isGoogleLoading = false;


  final AuthService _auth = AuthService(); 
  

  void _handleLogin(String email, String password) async {
    setState(() {_isLoading = true;});

    try {
      await _auth.signInWithEmail(email, password);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // void _handleGoogleLogin() async {
  //   setState(() {
  //     _isGoogleLoading = true;
  //   });

  //   try {
  //   // Kick off Google OAuth. On mobile this opens a browser and returns via deep link.
  //   final response = await supabase.auth.signInWithOAuth(
  //     OAuthProvider.google,
  //     redirectTo: 'com.skinkair_ai.app://login-callback',
  //     // authScreenLaunchMode: LaunchMode.externalApplication, // optional on mobile
  //   );
  //   if (response) {
  //     print('Google OAuth log-in initiated. Check browser for authentication.');
  //   } else {
  //     _showError('Google log-in could not be started.');
  //   }
  // } catch (e) {
  //   _showError('Google log-in failed. Please try again.');
  // } finally {
  //   if (mounted) setState(() => _isGoogleLoading = false);
  // }
  // }


  void _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);
    try {
      await _auth.signInWithGoogle();
      final isNewUser = _auth.isNewUser;

      if (isNewUser) {
        // New User -> Onboarding
        Navigator.pushReplacementNamed(context, '/onboarding-flow');
      } else {
        // Existing User -> Home
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

    void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.getSemanticColor(type: 'error', isLight: true),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
}

  void _handleSignupTap() {
    Navigator.pushNamed(context, '/registration-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 4.h),

                    // App Logo Section
                    const AppLogoWidget(),
                    SizedBox(height: 6.h),

                    // Welcome Text
                    Text(
                      'Welcome Back',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),

                    Text(
                      'Sign in to continue your skincare journey',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),

                    // Login Form
                    LoginFormWidget(
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
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
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
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
                    GoogleOAuthButtonWidget(
                      onGoogleLogin: _handleGoogleLogin,
                      isLoading: _isGoogleLoading,
                    ),
                    SizedBox(height: 4.h),

                    // Sign Up Link
                    SignupLinkWidget(
                      onSignupTap: _handleSignupTap,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
