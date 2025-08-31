import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceVisualizationWidget extends StatefulWidget {
  final bool isListening;
  final VoidCallback onMicrophoneTap;

  const VoiceVisualizationWidget({
    Key? key,
    required this.isListening,
    required this.onMicrophoneTap,
  }) : super(key: key);

  @override
  State<VoiceVisualizationWidget> createState() =>
      _VoiceVisualizationWidgetState();
}

class _VoiceVisualizationWidgetState extends State<VoiceVisualizationWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _ringController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _ringAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _ringController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _ringAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(VoiceVisualizationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _startAnimations();
    } else if (!widget.isListening && oldWidget.isListening) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _ringController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _ringController.stop();
    _pulseController.reset();
    _ringController.reset();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer visualization rings
          if (widget.isListening) ...[
            AnimatedBuilder(
              animation: _ringAnimation,
              builder: (context, child) {
                return Container(
                  width: 35.w * (1 + _ringAnimation.value * 0.5),
                  height: 35.w * (1 + _ringAnimation.value * 0.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor.withValues(
                        alpha: 0.3 * (1 - _ringAnimation.value),
                      ),
                      width: 2,
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _ringAnimation,
              builder: (context, child) {
                return Container(
                  width: 30.w * (1 + _ringAnimation.value * 0.3),
                  height: 30.w * (1 + _ringAnimation.value * 0.3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor.withValues(
                        alpha: 0.5 * (1 - _ringAnimation.value),
                      ),
                      width: 1.5,
                    ),
                  ),
                );
              },
            ),
          ],
          // Main microphone button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isListening ? _pulseAnimation.value : 1.0,
                child: GestureDetector(
                  onTap: widget.onMicrophoneTap,
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isListening
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.surface,
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          blurRadius: widget.isListening ? 20 : 10,
                          spreadRadius: widget.isListening ? 5 : 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: widget.isListening ? 'mic' : 'mic_none',
                        color: widget.isListening
                            ? AppTheme.lightTheme.colorScheme.surface
                            : AppTheme.lightTheme.primaryColor,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
