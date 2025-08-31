import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
  }) : super(key: key);

  PasswordStrength _getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return AppTheme.lightTheme.colorScheme.error;
      case PasswordStrength.medium:
        return AppTheme.getSemanticColor(type: 'warning', isLight: true);
      case PasswordStrength.strong:
        return AppTheme.getSemanticColor(type: 'success', isLight: true);
      case PasswordStrength.none:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.none:
        return '';
    }
  }

  double _getStrengthProgress(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
      case PasswordStrength.none:
        return 0.0;
    }
  }

  List<String> _getPasswordSuggestions(String password) {
    List<String> suggestions = [];

    if (password.length < 8) {
      suggestions.add('Use at least 8 characters');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      suggestions.add('Add uppercase letters');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      suggestions.add('Add lowercase letters');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      suggestions.add('Add numbers');
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      suggestions.add('Add special characters');
    }

    return suggestions;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _getPasswordStrength(password);
    final strengthColor = _getStrengthColor(strength);
    final strengthText = _getStrengthText(strength);
    final progress = _getStrengthProgress(strength);
    final suggestions = _getPasswordSuggestions(password);

    return password.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: strengthColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    strengthText,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: strengthColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (suggestions.isNotEmpty &&
                  strength != PasswordStrength.strong) ...[
                SizedBox(height: 1.h),
                ...suggestions.take(2).map((suggestion) => Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.8.h, right: 2.w),
                            width: 1.w,
                            height: 1.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              suggestion,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          );
  }
}

enum PasswordStrength { none, weak, medium, strong }
