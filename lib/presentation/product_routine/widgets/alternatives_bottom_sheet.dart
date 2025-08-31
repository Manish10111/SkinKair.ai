import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlternativesBottomSheet extends StatefulWidget {
  final String productCategory;
  final List<Map<String, dynamic>> alternatives;
  final Function(Map<String, dynamic>)? onProductSelected;

  const AlternativesBottomSheet({
    Key? key,
    required this.productCategory,
    required this.alternatives,
    this.onProductSelected,
  }) : super(key: key);

  @override
  State<AlternativesBottomSheet> createState() =>
      _AlternativesBottomSheetState();
}

class _AlternativesBottomSheetState extends State<AlternativesBottomSheet> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Budget-Friendly',
    'Premium',
    'Natural',
    'Sensitive Skin'
  ];

  List<Map<String, dynamic>> get _filteredAlternatives {
    if (_selectedFilter == 'All') {
      return widget.alternatives;
    }
    return widget.alternatives.where((product) {
      final tags = (product['tags'] as List?)?.cast<String>() ?? [];
      return tags.contains(_selectedFilter.toLowerCase().replaceAll('-', ' '));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Alternative ${widget.productCategory}',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          // Filter chips
          Container(
            height: 6.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  selectedColor:
                      AppTheme.lightTheme.colorScheme.primaryContainer,
                  labelStyle:
                      AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimaryContainer
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          // Alternatives list
          Expanded(
            child: _filteredAlternatives.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'search_off',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 12.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No alternatives found',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Try adjusting your filter selection',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: _filteredAlternatives.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final product = _filteredAlternatives[index];
                      return _buildAlternativeCard(product);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeCard(Map<String, dynamic> product) {
    final productName = product['name'] as String? ?? 'Unknown Product';
    final productBrand = product['brand'] as String? ?? 'Unknown Brand';
    final productImage = product['image'] as String? ?? '';
    final productPrice = product['price'] as String? ?? '\$0.00';
    final productRating = (product['rating'] as num?)?.toDouble() ?? 0.0;
    final productBenefits =
        (product['benefits'] as List?)?.cast<String>() ?? [];
    final productTags = (product['tags'] as List?)?.cast<String>() ?? [];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
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
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      productBrand,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Text(
                          productPrice,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: Colors.amber,
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              productRating.toStringAsFixed(1),
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (productBenefits.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Key Benefits:',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            ...productBenefits.take(2).map((benefit) => Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle_outline',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          benefit,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          if (productTags.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: productTags
                  .take(3)
                  .map((tag) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.primaryContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag.toUpperCase(),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          SizedBox(height: 2.h),
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onProductSelected?.call(product);
                Navigator.pop(context);
              },
              child: Text('Select This Product'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
