import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsUsed;
  final VoidCallback? onSetReminder;
  final VoidCallback? onViewAlternatives;

  const ProductCardWidget({
    Key? key,
    required this.product,
    this.onTap,
    this.onMarkAsUsed,
    this.onSetReminder,
    this.onViewAlternatives,
  }) : super(key: key);

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final productName = product['name'] as String? ?? 'Unknown Product';
    final productBrand = product['brand'] as String? ?? 'Unknown Brand';
    final productImage = product['image'] as String? ?? '';
    final productBenefits =
        (product['benefits'] as List?)?.cast<String>() ?? [];
    final productInstructions = product['instructions'] as String? ?? '';
    final productIngredients =
        (product['ingredients'] as List?)?.cast<String>() ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
          // Main product card content
          GestureDetector(
            onTap: widget.onTap ?? _toggleExpanded,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Product image
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    ),
                    child: productImage.isNotEmpty
                        ? CustomImageWidget(
                            imageUrl: productImage,
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: 'local_pharmacy',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 8.w,
                            ),
                          ),
                  ),
                  SizedBox(width: 4.w),
                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          productBrand,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (productBenefits.isNotEmpty) ...[
                          SizedBox(height: 1.h),
                          Text(
                            productBenefits.take(2).join(' • '),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Expand/collapse icon
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    height: 1,
                  ),
                  SizedBox(height: 2.h),
                  // Usage instructions
                  if (productInstructions.isNotEmpty) ...[
                    Text(
                      'Usage Instructions',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      productInstructions,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                  ],
                  // Key benefits
                  if (productBenefits.isNotEmpty) ...[
                    Text(
                      'Key Benefits',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...productBenefits.map((benefit) => Padding(
                          padding: EdgeInsets.only(bottom: 0.5.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 2.h),
                  ],
                  // Ingredients
                  if (productIngredients.isNotEmpty) ...[
                    Text(
                      'Key Ingredients',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: productIngredients
                          .map((ingredient) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  ingredient,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 2.h),
                  ],
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.onMarkAsUsed,
                          icon: CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 4.w,
                          ),
                          label: Text('Mark as Used'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.onSetReminder,
                          icon: CustomIconWidget(
                            iconName: 'notifications',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 4.w,
                          ),
                          label: Text('Reminder'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: widget.onViewAlternatives,
                      icon: CustomIconWidget(
                        iconName: 'swap_horiz',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 4.w,
                      ),
                      label: Text('See More Options'),
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
