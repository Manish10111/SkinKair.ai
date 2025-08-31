import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing SkinKair AI...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo breathing animation
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Progress animation
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.repeat(reverse: true);
    _progressAnimationController.forward();

    // Listen to progress animation
    _progressAnimation.addListener(() {
      setState(() {
        _progress = _progressAnimation.value;
      });
    });
  }

  Future<void> _startInitialization() async {
    try {
      // Step 1: Initialize voice services
      await _updateStatus('Initializing voice services...', 0.2);
      await _initializeVoiceServices();

      // Step 2: Check authentication
      await _updateStatus('Checking authentication...', 0.4);
      final isAuthenticated = await _checkAuthentication();

      // Step 3: Load user preferences
      await _updateStatus('Loading preferences...', 0.6);
      await _loadUserPreferences();

      // Step 4: Prepare skincare data
      await _updateStatus('Preparing skincare data...', 0.8);
      await _prepareCachedData();

      // Step 5: Complete initialization
      await _updateStatus('Ready!', 1.0);
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate based on authentication status
      _navigateToNextScreen(isAuthenticated);
    } catch (e) {
      await _handleInitializationError(e);
    }
  }

  Future<void> _updateStatus(String status, double progress) async {
    setState(() {
      _initializationStatus = status;
      _progress = progress;
    });
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _initializeVoiceServices() async {
    try {
      // Simulate Murf.ai TTS initialization
      await Future.delayed(const Duration(milliseconds: 600));

      // Simulate AssemblyAI speech recognition initialization
      await Future.delayed(const Duration(milliseconds: 400));
    } catch (e) {
      // Voice services failed - app will degrade to text-only mode
      debugPrint('Voice services initialization failed: $e');
    }
  }

  Future<bool> _checkAuthentication() async {
    try {
      // Check for stored authentication tokens
      await Future.delayed(const Duration(milliseconds: 300));

      // Simulate token validation
      // In real implementation, this would check SharedPreferences or secure storage
      return false; // For demo, assume user is not authenticated
    } catch (e) {
      debugPrint('Authentication check failed: $e');
      return false;
    }
  }

  Future<void> _loadUserPreferences() async {
    try {
      // Load theme preferences, language settings, etc.
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      debugPrint('Failed to load user preferences: $e');
    }
  }

  Future<void> _prepareCachedData() async {
    try {
      // Prepare cached skincare product data
      await Future.delayed(const Duration(milliseconds: 400));
    } catch (e) {
      debugPrint('Failed to prepare cached data: $e');
    }
  }

  Future<void> _handleInitializationError(dynamic error) async {
    setState(() {
      _initializationStatus = 'Initialization failed';
      _isInitializing = false;
    });

    // Show retry option after 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    if (mounted) {
      _showRetryDialog();
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Connection Error',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Unable to initialize the app. Please check your internet connection and try again.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryInitialization();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _initializationStatus = 'Retrying initialization...';
      _progress = 0.0;
    });

    _progressAnimationController.reset();
    _progressAnimationController.forward();
    _startInitialization();
  }

  void _navigateToNextScreen(bool isAuthenticated) {
    if (!mounted) return;

    if (isAuthenticated) {
      // User is authenticated, go to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // User is not authenticated, go to login
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo section with breathing animation
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Status and progress section
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Status text
                      Text(
                        _initializationStatus,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 3.h),

                      // Progress indicator
                      _isInitializing
                          ? _buildProgressIndicator()
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      // The change is here:
      child: Padding(
        padding: EdgeInsets.all(4.w), // Adds some space around your logo
        child: Image.asset(
          'assets/images/icon.png', // The path to your new logo
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        // Progress bar
        Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Progress percentage
        Text(
          '${(_progress * 100).toInt()}%',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
