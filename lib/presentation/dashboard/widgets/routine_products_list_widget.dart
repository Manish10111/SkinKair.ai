import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './product_card_widget.dart';

class RoutineProductsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onMarkAsUsed;
  final Function(Map<String, dynamic>) onViewDetails;
  final Function(Map<String, dynamic>) onSetReminder;

  const RoutineProductsListWidget({
    Key? key,
    required this.products,
    required this.onMarkAsUsed,
    required this.onViewDetails,
    required this.onSetReminder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Your 5-Step Routine',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 35.h,
          child: products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'spa',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No routine set up yet',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Complete your voice onboarding to get personalized recommendations',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/voice-onboarding');
                        },
                        child: const Text('Start Setup'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCardWidget(
                      product: product,
                      onMarkAsUsed: () => onMarkAsUsed(product),
                      onViewDetails: () => onViewDetails(product),
                      onSetReminder: () => onSetReminder(product),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
