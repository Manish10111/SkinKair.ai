import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrackingPreviewWidget extends StatefulWidget {
  const TrackingPreviewWidget({super.key});

  @override
  State<TrackingPreviewWidget> createState() => _TrackingPreviewWidgetState();
}

class _TrackingPreviewWidgetState extends State<TrackingPreviewWidget>
    with TickerProviderStateMixin {
  late AnimationController _chartController;
  late Animation<double> _chartAnimation;
  late AnimationController _voiceTipController;
  late Animation<double> _voiceTipAnimation;

  final List<Map<String, dynamic>> _mockUsageData = [
    {'day': 'Mon', 'usage': 85.0},
    {'day': 'Tue', 'usage': 92.0},
    {'day': 'Wed', 'usage': 78.0},
    {'day': 'Thu', 'usage': 95.0},
    {'day': 'Fri', 'usage': 88.0},
    {'day': 'Sat', 'usage': 90.0},
    {'day': 'Sun', 'usage': 82.0},
  ];

  @override
  void initState() {
    super.initState();

    _chartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.easeInOut),
    );

    _voiceTipController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _voiceTipAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _voiceTipController, curve: Curves.easeInOut),
    );

    _chartController.forward();
    _voiceTipController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _chartController.dispose();
    _voiceTipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 85.w,
      height: 55.h,
      child: Column(
        children: [
          // Usage Chart
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'analytics',
                        color: AppTheme.primaryLight,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Weekly Usage Tracking',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _chartAnimation,
                      builder: (context, child) {
                        return BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() < _mockUsageData.length) {
                                      return Text(
                                        _mockUsageData[value.toInt()]['day']
                                            as String,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            barGroups:
                                _mockUsageData.asMap().entries.map((entry) {
                              final index = entry.key;
                              final data = entry.value;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: (data['usage'] as double) *
                                        _chartAnimation.value,
                                    color: AppTheme.primaryLight,
                                    width: 4.w,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Voice Tips Preview
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryLight.withValues(alpha: 0.1),
                    AppTheme.primaryLight.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _voiceTipAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _voiceTipAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryLight
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: CustomIconWidget(
                                iconName: 'volume_up',
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Voice Tips',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              'Personalized audio guidance',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'lightbulb',
                          color: AppTheme.primaryLight,
                          size: 18,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            '"Remember to apply sunscreen 15 minutes before going outside for maximum protection."',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
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
