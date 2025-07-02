import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VerificationFooterWidget extends StatelessWidget {
  final VoidCallback onSkipVerification;
  final VoidCallback onBackToLogin;

  const VerificationFooterWidget({
    super.key,
    required this.onSkipVerification,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Skip for now option
        TextButton(
          onPressed: onSkipVerification,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          ),
          child: Text(
            'Skip for Now',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Divider with "or"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                'or',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Back to login option
        TextButton(
          onPressed: onBackToLogin,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'login',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Back to Login',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
