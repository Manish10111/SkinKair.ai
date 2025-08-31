import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;
  final Color? inactiveColor;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
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
      children: [
        Text(
          '$currentStep',
          style: theme.textTheme.titleMedium?.copyWith(
            color: effectiveActiveColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          'of',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          '$totalSteps',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: effectiveInactiveColor,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: currentStep / totalSteps,
              child: Container(
                decoration: BoxDecoration(
                  color: effectiveActiveColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
