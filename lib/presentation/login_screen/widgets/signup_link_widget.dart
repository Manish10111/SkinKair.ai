import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SignupLinkWidget extends StatelessWidget {
  final VoidCallback onSignupTap;

  const SignupLinkWidget({
    Key? key,
    required this.onSignupTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New user? ',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          GestureDetector(
            onTap: onSignupTap,
            child: Text(
              'Sign Up',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
