import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onMarkAsUsed;
  final VoidCallback onViewDetails;
  final VoidCallback onSetReminder;

  const ProductCardWidget({
    Key? key,
    required this.product,
    required this.onMarkAsUsed,
    required this.onViewDetails,
    required this.onSetReminder,
  }) : super(key: key);

  String _getTimeAgo(DateTime? lastUsed) {
    if (lastUsed == null) return 'Never used';

    final now = DateTime.now();
    final difference = now.difference(lastUsed);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'View Details',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onViewDetails();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'check_circle',
                color:
                    AppTheme.getSemanticColor(type: 'success', isLight: true),
                size: 24,
              ),
              title: Text(
                'Mark as Used',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onMarkAsUsed();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color:
                    AppTheme.getSemanticColor(type: 'warning', isLight: true),
                size: 24,
              ),
              title: Text(
                'Set Reminder',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onSetReminder();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isUsedToday = product['usedToday'] as bool? ?? false;
    final DateTime? lastUsed = product['lastUsed'] as DateTime?;

    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: Container(
        width: 40.w,
        margin: EdgeInsets.only(right: 3.w),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUsedToday
                ? AppTheme.getSemanticColor(type: 'success', isLight: true)
                : AppTheme.lightTheme.colorScheme.outline,
            width: isUsedToday ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: product['image'] as String? ?? '',
                    width: double.infinity,
                    height: 20.w,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isUsedToday)
                  Positioned(
                    top: 1.w,
                    right: 1.w,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.getSemanticColor(
                            type: 'success', isLight: true),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.w),
            Text(
              product['name'] as String? ?? 'Unknown Product',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 1.w),
            Text(
              product['category'] as String? ?? 'Skincare',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 2.w),
            Text(
              _getTimeAgo(lastUsed),
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isUsedToday
                    ? AppTheme.getSemanticColor(type: 'success', isLight: true)
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 2.w),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isUsedToday ? null : onMarkAsUsed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUsedToday
                      ? AppTheme.getSemanticColor(
                          type: 'success', isLight: true)
                      : AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isUsedToday ? 'Used Today' : 'Mark Used',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
