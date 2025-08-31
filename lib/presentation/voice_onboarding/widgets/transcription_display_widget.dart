import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TranscriptionDisplayWidget extends StatelessWidget {
  final String transcriptionText;
  final bool isListening;

  const TranscriptionDisplayWidget({
    Key? key,
    required this.transcriptionText,
    required this.isListening,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: BoxConstraints(
        minHeight: 12.h,
        maxHeight: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'record_voice_over',
                color: isListening
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                isListening ? 'Listening...' : 'Voice Recognition',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: isListening
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isListening) ...[
                SizedBox(width: 2.w),
                SizedBox(
                  width: 4.w,
                  height: 4.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                transcriptionText.isEmpty
                    ? (isListening
                        ? 'Speak now...'
                        : 'Tap the microphone to start speaking')
                    : transcriptionText,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: transcriptionText.isEmpty
                      ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
