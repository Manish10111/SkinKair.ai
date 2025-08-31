// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class AppTheme {
  static TextStyle otpDigitStyle({required bool isLight}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: isLight ? Colors.black : Colors.white,
    );
  }

  static Color getSuccessColor(bool isLight) {
    return isLight ? Colors.green : Colors.lightGreenAccent;
  }
}


class OtpDigitInputWidget extends StatelessWidget {
  final String digit;
  final bool isActive;
  final bool hasError;
  final VoidCallback? onTap;

  

  const OtpDigitInputWidget({
    Key? key,
    required this.digit,
    this.isActive = false,
    this.hasError = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: hasError
                ? Theme.of(context).colorScheme.error
                : isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
            width: hasError || isActive ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: digit.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      digit,
                      style: AppTheme.otpDigitStyle(isLight: !isDarkMode),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.getSuccessColor(!isDarkMode),
                      size: 16,
                    ),
                  ],
                )
              : isActive
                  ? Container(
                      width: 2,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    )
                  : null,
        ),
      ),
    );
  }
}
