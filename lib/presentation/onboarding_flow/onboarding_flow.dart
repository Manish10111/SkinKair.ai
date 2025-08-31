import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/onboarding_page_widget.dart';
import 'widgets/page_dots_indicator_widget.dart';
import 'widgets/progress_indicator_widget.dart';
import 'widgets/qr_scanner_preview_widget.dart';
import 'widgets/routine_visualization_widget.dart';
import 'widgets/tracking_preview_widget.dart';
import './widgets/voice_waveform_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  int _currentPage = 0;
  bool _isVoiceDemoActive = false;
  // bool _hasRequestedPermissions = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Meet Your AI Skincare Coach',
      'description':
          'Experience personalized skincare guidance through natural voice conversations. Just speak naturally and get expert advice tailored to your skin.',
      'illustration': 'voice',
      'permissions': ['microphone'],
    },
    {
      'title': 'Scan Products Instantly',
      'description':
          'Simply scan any skincare product with your camera to get instant ingredient analysis and compatibility checks with your routine.',
      'illustration': 'qr_scanner',
      'permissions': ['camera'],
    },
    {
      'title': 'Get Your Perfect Routine',
      'description':
          'Receive a personalized 5-step skincare routine based on your skin type, concerns, and lifestyle. Each step is carefully selected for optimal results.',
      'illustration': 'routine',
      'permissions': [],
    },
    {
      'title': 'Track Your Progress',
      'description':
          'Monitor your skincare journey with detailed usage tracking, progress photos, and daily voice tips to keep you motivated and informed.',
      'illustration': 'tracking',
      'permissions': [],
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, '/voice-onboarding');
  }

  // Future<void> _handleTryFeature(int pageIndex) async {
  //   HapticFeedback.lightImpact();

  //   switch (pageIndex) {
  //     case 0:
  //       await _tryVoiceFeature();
  //       break;
  //     case 1:
  //       await _tryCameraFeature();
  //       break;
  //   }
  // }

  // Future<void> _tryVoiceFeature() async {
  //   setState(() {
  //     _isVoiceDemoActive = true;
  //   });

  //   // Simulate voice interaction demo
  //   await Future.delayed(const Duration(seconds: 3));

  //   if (mounted) {
  //     setState(() {
  //       _isVoiceDemoActive = false;
  //     });

  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: const Text(
  //     //         'Voice feature ready! Continue to experience full functionality.'),
  //     //     backgroundColor: AppTheme.primaryLight,
  //     //     behavior: SnackBarBehavior.floating,
  //     //     shape:
  //     //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     //   ),
  //     // );
  //   }
  // }

  // Future<void> _tryCameraFeature() async {
  //   if (!_hasRequestedPermissions) {
  //     setState(() {
  //       _hasRequestedPermissions = true;
  //     });

  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: const Text(
  //     //         'Camera preview ready! Continue to access full scanning features.'),
  //     //     backgroundColor: AppTheme.primaryLight,
  //     //     behavior: SnackBarBehavior.floating,
  //     //     shape:
  //     //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     //   ),
  //     // );
  //   }
  // }

  Widget _buildIllustration(String type) {
    switch (type) {
      case 'voice':
        return SizedBox(
          height: 40.h, // You can adjust this value
          child: VoiceWaveformWidget(isAnimating: _isVoiceDemoActive),
        );
      case 'qr_scanner':
        return SizedBox(
          height: 40.h, // You can adjust this value
          child: const QrScannerPreviewWidget(),
        );
      case 'routine':
        return const RoutineVisualizationWidget();
      case 'tracking':
        return const TrackingPreviewWidget();
      default:
        return Container(
          width: 60.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'spa',
              color: AppTheme.primaryLight,
              size: 48,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                _isVoiceDemoActive = false;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              final data = _onboardingData[index];
              return OnboardingPageWidget(
                title: data['title'] as String,
                description: data['description'] as String,
                illustration:
                    _buildIllustration(data['illustration'] as String),
              );
            },
          ),

          // Top progress and skip button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ProgressIndicatorWidget(
                      currentStep: _currentPage + 1,
                      totalSteps: _onboardingData.length,
                    ),
                  ),
                  TextButton(
                    onPressed: _skipOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurfaceVariant,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    ),
                    child: Text(
                      'Skip',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page dots indicator
                    PageDotsIndicatorWidget(
                      currentPage: _currentPage,
                      totalPages: _onboardingData.length,
                    ),

                    SizedBox(height: 3.h),

                    // Next button
                    AnimatedBuilder(
                      animation: _buttonAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _buttonAnimation.value,
                          child: SizedBox(
                            width: double.infinity,
                            height: 6.h,
                            child: ElevatedButton(
                              onPressed: () {
                                _buttonController.forward().then((_) {
                                  _buttonController.reverse();
                                  _nextPage();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryLight,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor:
                                    AppTheme.primaryLight.withValues(alpha: 0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentPage == _onboardingData.length - 1
                                        ? 'Get Started'
                                        : 'Next',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  CustomIconWidget(
                                    iconName: _currentPage ==
                                            _onboardingData.length - 1
                                        ? 'rocket_launch'
                                        : 'arrow_forward',
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
