import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VerificationActionsWidget extends StatelessWidget {
  final bool isResendLoading;
  final int resendCountdown;
  final VoidCallback onOpenEmailApp;
  final VoidCallback onResendEmail;
  final VoidCallback onChangeEmail;

  const VerificationActionsWidget({
    super.key,
    required this.isResendLoading,
    required this.resendCountdown,
    required this.onOpenEmailApp,
    required this.onResendEmail,
    required this.onChangeEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Open Email App button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton.icon(
            onPressed: onOpenEmailApp,
            icon: CustomIconWidget(
              iconName: 'open_in_new',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text(
              'Open Email App',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Resend Email button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton(
            onPressed:
                (resendCountdown > 0 || isResendLoading) ? null : onResendEmail,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: (resendCountdown > 0 || isResendLoading)
                    ? AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.5)
                    : AppTheme.lightTheme.colorScheme.primary,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isResendLoading
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'refresh',
                        color: (resendCountdown > 0)
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        resendCountdown > 0
                            ? 'Resend in ${resendCountdown}s'
                            : 'Resend Email',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: (resendCountdown > 0)
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        SizedBox(height: 3.h),

        // Change Email link
        TextButton(
          onPressed: onChangeEmail,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Change Email Address',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
