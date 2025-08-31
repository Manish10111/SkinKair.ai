import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final bool isAnimating; // We will keep this but ignore it for starting
  final Color? waveColor;

  const VoiceWaveformWidget({
    super.key,
    this.isAnimating = false,
    this.waveColor,
  });

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _barControllers;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();

    _barControllers = List.generate(
      7,
          (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index *50)),
        vsync: this,
      ),
    );

    _barAnimations = _barControllers.map((controller) {
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // FIX: The animation now starts automatically when the widget is built.
    _startAnimation();
  }

  // This function is no longer needed as we start automatically
  // @override
  // void didUpdateWidget(VoiceWaveformWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.isAnimating != oldWidget.isAnimating) {
  //     if (widget.isAnimating) {
  //       _startAnimation();
  //     } else {
  //       _stopAnimation();
  //     }
  //   }
  // }

  void _startAnimation() {
    for (int i = 0; i < _barControllers.length; i++) {
      // Small delay for each bar to create a staggered effect
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) {
          _barControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _stopAnimation() {
    for (final controller in _barControllers) {
      controller.stop();
      controller.reset();
    }
  }

  @override
  void dispose() {
    for (final controller in _barControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = widget.waveColor ?? AppTheme.primaryLight;

    return Container(
      width: 60.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: effectiveColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(7, (index) {
            return AnimatedBuilder(
              animation: _barAnimations[index],
              builder: (context, child) {
                // Base height for the bars
                double baseHeight = 4.h;
                // Variable height to add some randomness
                double variableHeight = (index % 3) * 2.h;
                return Container(
                  width: 4.w,
                  height: (baseHeight + variableHeight) * _barAnimations[index].value,
                  decoration: BoxDecoration(
                    color: effectiveColor,
                    borderRadius: BorderRadius.circular(2.w),
                    boxShadow: [
                      BoxShadow(
                        color: effectiveColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

