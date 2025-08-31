import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestionDisplayWidget extends StatelessWidget {
  final String question;
  final String? subtitle;
  final VoidCallback? onReplay;

  const QuestionDisplayWidget({
    Key? key,
    required this.question,
    this.subtitle,
    this.onReplay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      padding: EdgeInsets.all(1.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
          ],
          Text(
            question,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          if (onReplay != null) ...[
            SizedBox(height: 1.h),
            TextButton.icon(
              onPressed: onReplay,
              icon: CustomIconWidget(
                iconName: 'volume_up',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              label: Text(
                'Replay Question',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
