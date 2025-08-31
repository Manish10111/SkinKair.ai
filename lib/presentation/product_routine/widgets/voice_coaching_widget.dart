import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceCoachingWidget extends StatefulWidget {
  final String currentStep;
  final int stepNumber;
  final int totalSteps;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onPlayAudio;

  const VoiceCoachingWidget({
    Key? key,
    required this.currentStep,
    required this.stepNumber,
    required this.totalSteps,
    this.onNext,
    this.onPrevious,
    this.onPlayAudio,
  }) : super(key: key);

  @override
  State<VoiceCoachingWidget> createState() => _VoiceCoachingWidgetState();
}

class _VoiceCoachingWidgetState extends State<VoiceCoachingWidget>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _toggleAudio() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _waveController.repeat();
    } else {
      _waveController.stop();
    }

    widget.onPlayAudio?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primaryContainer,
            AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with step indicator
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                child: Center(
                  child: Text(
                    '${widget.stepNumber}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${widget.stepNumber} of ${widget.totalSteps}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme
                            .lightTheme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    LinearProgressIndicator(
                      value: widget.stepNumber / widget.totalSteps,
                      backgroundColor: AppTheme
                          .lightTheme.colorScheme.onPrimaryContainer
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Voice coaching content
          Text(
            widget.currentStep,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          // Audio visualization and play button
          GestureDetector(
            onTap: _toggleAudio,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.lightTheme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Audio waves animation
                  if (_isPlaying)
                    AnimatedBuilder(
                      animation: _waveAnimation,
                      builder: (context, child) {
                        return Container(
                          width: (25.w + 10.w * _waveAnimation.value),
                          height: (25.w + 10.w * _waveAnimation.value),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(
                                      alpha: 0.3 * (1 - _waveAnimation.value)),
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  // Play/Pause icon
                  CustomIconWidget(
                    iconName: _isPlaying ? 'pause' : 'play_arrow',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 8.w,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Navigation buttons
          Row(
            children: [
              // Previous button
              if (widget.stepNumber > 1)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onPrevious,
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      size: 4.w,
                    ),
                    label: Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      side: BorderSide(
                        color: AppTheme
                            .lightTheme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.5),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                )
              else
                const Spacer(),
              if (widget.stepNumber > 1 &&
                  widget.stepNumber < widget.totalSteps)
                SizedBox(width: 3.w),
              // Next/Complete button
              if (widget.stepNumber < widget.totalSteps)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onNext,
                    icon: CustomIconWidget(
                      iconName: 'arrow_forward',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 4.w,
                    ),
                    label: Text('Next Step'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onNext,
                    icon: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 4.w,
                    ),
                    label: Text('Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onTertiary,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          // Voice tip
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'lightbulb',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Tip: Take your time with each step for best results',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
