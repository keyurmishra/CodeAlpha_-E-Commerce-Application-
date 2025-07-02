import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final List<String> unmetRequirements;

  const PasswordRequirementsWidget({
    super.key,
    required this.unmetRequirements,
  });

  @override
  Widget build(BuildContext context) {
    final allRequirements = [
      'At least 8 characters',
      'One uppercase letter',
      'One lowercase letter',
      'One number',
      'One special character'
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...allRequirements.map((requirement) {
            final isMet = !unmetRequirements.contains(requirement);
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: isMet ? 'check_circle' : 'radio_button_unchecked',
                    color: isMet
                        ? AppTheme.successLight
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      requirement,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isMet
                            ? AppTheme.successLight
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
