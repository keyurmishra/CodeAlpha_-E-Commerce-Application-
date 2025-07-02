import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlternativeOptionsWidget extends StatelessWidget {
  final VoidCallback onDeactivateAccount;

  const AlternativeOptionsWidget({
    super.key,
    required this.onDeactivateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'lightbulb_outline',
                  color: AppTheme.warningLight,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Consider These Alternatives',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.warningLight,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Instead of permanently deleting your account, you might want to consider:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),

            // Account Deactivation Option
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'pause_circle_outline',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Account Deactivation',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Temporarily disable your account while keeping your data safe. You can reactivate anytime.',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 2.h),
                  _buildFeatureComparison(),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onDeactivateAccount,
                      child: const Text('Deactivate Instead'),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Other Options
            _buildAlternativeOption(
              icon: 'notifications_off',
              title: 'Disable Notifications',
              description:
                  'Turn off email and push notifications without affecting your account.',
              action: 'Manage Notifications',
              onTap: () {
                Navigator.of(context).pushNamed('/profile-management-screen');
              },
            ),

            SizedBox(height: 2.h),

            _buildAlternativeOption(
              icon: 'privacy_tip',
              title: 'Update Privacy Settings',
              description: 'Control what data is shared and how it\'s used.',
              action: 'Privacy Settings',
              onTap: () {
                Navigator.of(context).pushNamed('/profile-management-screen');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureComparison() {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Feature',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
                child: Text(
                  'Deactivate',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 20.w,
                child: Text(
                  'Delete',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Divider(height: 2.h),
          _buildComparisonRow('Data Recovery', true, false),
          _buildComparisonRow('Reactivation', true, false),
          _buildComparisonRow('Order History', true, false),
          _buildComparisonRow('Saved Preferences', true, false),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String feature, bool deactivate, bool delete) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              feature,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 20.w,
            child: Center(
              child: CustomIconWidget(
                iconName: deactivate ? 'check' : 'close',
                color: deactivate
                    ? AppTheme.successLight
                    : AppTheme.lightTheme.colorScheme.error,
                size: 16,
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
            child: Center(
              child: CustomIconWidget(
                iconName: delete ? 'check' : 'close',
                color: delete
                    ? AppTheme.successLight
                    : AppTheme.lightTheme.colorScheme.error,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeOption({
    required String icon,
    required String title,
    required String description,
    required String action,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              action,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
