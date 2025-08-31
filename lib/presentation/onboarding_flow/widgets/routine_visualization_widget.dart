import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
// import '../../../theme/app_theme.dart';

class RoutineVisualizationWidget extends StatefulWidget {
  const RoutineVisualizationWidget({super.key});

  @override
  State<RoutineVisualizationWidget> createState() =>
      _RoutineVisualizationWidgetState();
}

class _RoutineVisualizationWidgetState extends State<RoutineVisualizationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _stepAnimations;

  final List<Map<String, dynamic>> _routineSteps = [
    {
      'icon': 'face_retouching_natural',
      'title': 'Face Wash',
      'subtitle': 'Personalized for your skin',
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon': 'water_drop',
      'title': 'Toner',
      'subtitle': 'To balance and prep',
      'color': const Color(0xFF2196F3),
    },
    {
      'icon': 'science',
      'title': 'Serum',
      'subtitle': 'To target specific concerns',
      'color': const Color(0xFF9C27B0),
    },
    {
      'icon': 'spa',
      'title': 'Moisturizer',
      'subtitle': 'To hydrate and protect',
      'color': const Color(0xFFFF9800),
    },
    {
      'icon': 'wb_sunny',
      'title': 'Sunscreen',
      'subtitle': 'For daily UV protection',
      'color': const Color(0xFFFFC107),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _stepAnimations = List.generate(_routineSteps.length, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            0.5 + (index * 0.1),
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'Your Personalized 5-Step Routine',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryLight,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        // FIX: Replaced ListView.builder with a simple Column.
        // This resolves the "infinite height" layout crash.
        Column(
          children: List.generate(_routineSteps.length, (index) {
            return AnimatedBuilder(
              animation: _stepAnimations[index],
              builder: (context, child) {
                return Opacity(
                  opacity: _stepAnimations[index].value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - _stepAnimations[index].value)),
                    child: child,
                  ),
                );
              },
              child: _buildStepTile(
                context: context,
                index: index,
                data: _routineSteps[index],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepTile({
    required BuildContext context,
    required int index,
    required Map<String, dynamic> data,
  }) {
    final theme = Theme.of(context);
    final color = data['color'] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Step number
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // Step content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  data['subtitle'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          // Icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: data['icon'] as String,
              color: color,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

