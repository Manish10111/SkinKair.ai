import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './password_strength_indicator.dart';
import './terms_privacy_checkbox.dart';

class RegistrationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isTermsAccepted;
  final VoidCallback togglePasswordVisibility;
  final VoidCallback toggleConfirmPasswordVisibility;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const RegistrationForm({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isTermsAccepted,
    required this.togglePasswordVisibility,
    required this.toggleConfirmPasswordVisibility,
    required this.onTermsChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
  }) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != widget.passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _onEmailSubmitted() {
    _passwordFocusNode.requestFocus();
  }

  void _onPasswordSubmitted() {
    _confirmPasswordFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          TextFormField(
            controller: widget.emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _onEmailSubmitted(),
            validator: _validateEmail,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: widget.passwordController,
            focusNode: _passwordFocusNode,
            obscureText: !widget.isPasswordVisible,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _onPasswordSubmitted(),
            onChanged: (_) =>
                setState(() {}), // Trigger rebuild for strength indicator
            validator: _validatePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Create a strong password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: widget.togglePasswordVisibility,
                icon: CustomIconWidget(
                  iconName: widget.isPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Password Strength Indicator
          PasswordStrengthIndicator(password: widget.passwordController.text),

          SizedBox(height: 3.h),

          // Confirm Password Field
          TextFormField(
            controller: widget.confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            obscureText: !widget.isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}), // Trigger rebuild for validation
            validator: _validateConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: widget.toggleConfirmPasswordVisibility,
                icon: CustomIconWidget(
                  iconName: widget.isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Terms and Privacy Checkbox
          TermsPrivacyCheckbox(
            isChecked: widget.isTermsAccepted,
            onChanged: widget.onTermsChanged,
            onTermsTap: widget.onTermsTap,
            onPrivacyTap: widget.onPrivacyTap,
          ),
        ],
      ),
    );
  }
}
