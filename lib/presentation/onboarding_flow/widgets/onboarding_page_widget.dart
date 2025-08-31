import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OnboardingPageWidget extends StatefulWidget {
  final String title;
  final String description;
  final Widget illustration;
  final VoidCallback? onTryFeature;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    this.onTryFeature,
  });

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget> {
  @override
  void initState() {
    super.initState();

    // Trigger automatically when the widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onTryFeature != null) {
        widget.onTryFeature!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: theme.brightness == Brightness.light
              ? [const Color.fromARGB(255, 234, 252, 228), const Color(0xFFE0F7FA)]
              : [const Color(0xFF1C1C1E), const Color(0xFF263238)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 7.h),
          // FIX: Wrapped the Column in a SingleChildScrollView to prevent overflow
          child: SingleChildScrollView(
            child: Column(
              children: [
                // FIX: Removed the 'Expanded' widget from here
                widget.illustration,
                SizedBox(height: 1.5.h),
                // FIX: And also removed the 'Expanded' widget from here
                Column(
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
