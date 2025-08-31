import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QrScannerPreviewWidget extends StatefulWidget {
  const QrScannerPreviewWidget({super.key});

  @override
  State<QrScannerPreviewWidget> createState() => _QrScannerPreviewWidgetState();
}

class _QrScannerPreviewWidgetState extends State<QrScannerPreviewWidget>
    with TickerProviderStateMixin {
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;
  late AnimationController _cornerController;
  late Animation<double> _cornerAnimation;

  @override
  void initState() {
    super.initState();

    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanLineController,
      curve: Curves.easeInOut,
    ));

    _cornerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cornerAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cornerController,
      curve: Curves.easeInOut,
    ));

    _scanLineController.repeat();
    _cornerController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _cornerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Camera preview background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface.withValues(alpha: 0.2),
                  theme.colorScheme.surface.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),

          // QR Code frame
          Center(
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  // Corner indicators
                  AnimatedBuilder(
                    animation: _cornerAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: 0,
                        left: 0,
                        child: Transform.scale(
                          scale: _cornerAnimation.value,
                          child: Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: AppTheme.primaryLight, width: 3),
                                left: BorderSide(
                                    color: AppTheme.primaryLight, width: 3),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _cornerAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: 0,
                        right: 0,
                        child: Transform.scale(
                          scale: _cornerAnimation.value,
                          child: Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: AppTheme.primaryLight, width: 3),
                                right: BorderSide(
                                    color: AppTheme.primaryLight, width: 3),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _cornerAnimation,
                    builder: (context, child) {
                      return Positioned(
                        bottom: 0,
                        left: 0,
                        child: Transform.scale(
                          scale: _cornerAnimation.value,
                          child: Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: AppTheme.primaryLight, width: 3),
                                left: BorderSide(
                                    color: AppTheme.primaryLight, width: 3),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _cornerAnimation,
                    builder: (context, child) {
                      return Positioned(
                        bottom: 0,
                        right: 0,
                        child: Transform.scale(
                          scale: _cornerAnimation.value,
                          child: Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: AppTheme.primaryLight, width: 3),
                                right: BorderSide(
                                    color: AppTheme.primaryLight, width: 3),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Scanning line
                  AnimatedBuilder(
                    animation: _scanLineAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: 40.w * _scanLineAnimation.value - 1,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppTheme.primaryLight,
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppTheme.primaryLight.withValues(alpha: 0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),



                ],
              ),
            ),
          ),

          // Sample product recognition
          Positioned(
            bottom: 2.h,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Product Recognized!',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
