import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class AnswerOptionWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerOptionWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 1.5.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryLight
              : (isLight ? Colors.white : theme.colorScheme.surface),
          borderRadius: BorderRadius.circular(100), // Makes it pill-shaped
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : theme.colorScheme.outline.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppTheme.primaryLight.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
