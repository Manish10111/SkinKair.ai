import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoutineTimerWidget extends StatefulWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  const RoutineTimerWidget({
    Key? key,
    this.onComplete,
    this.onPause,
    this.onResume,
  }) : super(key: key);

  @override
  State<RoutineTimerWidget> createState() => _RoutineTimerWidgetState();
}

class _RoutineTimerWidgetState extends State<RoutineTimerWidget>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _pulseController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
    widget.onPause?.call();
  }

  void _resumeTimer() {
    _startTimer();
    widget.onResume?.call();
  }

  void _completeTimer() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
    widget.onComplete?.call();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Timer header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'timer',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Routine Timer',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _isRunning
                      ? AppTheme.lightTheme.colorScheme.primaryContainer
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isRunning
                      ? 'Active'
                      : _isPaused
                          ? 'Paused'
                          : 'Stopped',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _isRunning
                        ? AppTheme.lightTheme.colorScheme.onPrimaryContainer
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Timer display
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isRunning ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _formatTime(_seconds),
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 3.h),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Pause/Resume button
              if (_isRunning)
                ElevatedButton.icon(
                  onPressed: _pauseTimer,
                  icon: CustomIconWidget(
                    iconName: 'pause',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
                  label: Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                  ),
                )
              else if (_isPaused)
                ElevatedButton.icon(
                  onPressed: _resumeTimer,
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
                  label: Text('Resume'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                  ),
                ),
              // Complete button
              ElevatedButton.icon(
                onPressed: _completeTimer,
                icon: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                label: Text('Complete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Progress indicator
          LinearProgressIndicator(
            value: _seconds / 600, // Assuming 10 minutes max routine
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Estimated routine time: 8-12 minutes',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
