import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoogleOAuthButtonWidget extends StatelessWidget {
  final VoidCallback onGoogleLogin;
  final bool isLoading;

  const GoogleOAuthButtonWidget({
    Key? key,
    required this.onGoogleLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 6.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onGoogleLogin,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                ] else ...[
                  CustomImageWidget(
                    imageUrl:
                        'https://developers.google.com/identity/images/g-logo.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 3.w),
                ],
                Flexible(
                  child: Text(
                    isLoading ? 'Signing in...' : 'Continue with Google',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
