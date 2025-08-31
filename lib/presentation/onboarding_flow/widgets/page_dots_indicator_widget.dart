import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PageDotsIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageDotsIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? AppTheme.primaryLight;
    final effectiveInactiveColor = inactiveColor ??
        theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: isActive ? 6.w : 2.w,
          height: 2.w,
          decoration: BoxDecoration(
            color: isActive ? effectiveActiveColor : effectiveInactiveColor,
            borderRadius: BorderRadius.circular(1.w),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: effectiveActiveColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
