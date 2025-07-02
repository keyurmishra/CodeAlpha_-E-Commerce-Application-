import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConfirmationStepsWidget extends StatelessWidget {
  final bool acknowledgeDataLoss;
  final TextEditingController passwordController;
  final bool passwordVerified;
  final bool isPasswordVisible;
  final bool isLoading;
  final ValueChanged<bool?> onAcknowledgeChanged;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onVerifyPassword;

  const ConfirmationStepsWidget({
    super.key,
    required this.acknowledgeDataLoss,
    required this.passwordController,
    required this.passwordVerified,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onAcknowledgeChanged,
    required this.onPasswordVisibilityToggle,
    required this.onVerifyPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmation Steps',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
            SizedBox(height: 3.h),

            // Step 1: Acknowledge Data Loss
            _buildConfirmationStep(
              stepNumber: '1',
              title: 'Acknowledge Data Loss',
              isCompleted: acknowledgeDataLoss,
              child: CheckboxListTile(
                value: acknowledgeDataLoss,
                onChanged: onAcknowledgeChanged,
                title: Text(
                  'I understand that all my data will be permanently deleted and cannot be recovered.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.lightTheme.colorScheme.error,
              ),
            ),

            SizedBox(height: 3.h),

            // Step 2: Password Verification
            _buildConfirmationStep(
              stepNumber: '2',
              title: 'Verify Your Password',
              isCompleted: passwordVerified,
              child: Column(
                children: [
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    enabled: !passwordVerified,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      hintText: 'Enter your current password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                      suffixIcon: IconButton(
                        onPressed: onPasswordVisibilityToggle,
                        icon: CustomIconWidget(
                          iconName: isPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  if (!passwordVerified) ...[
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : onVerifyPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : const Text('Verify Password'),
                      ),
                    ),
                  ],
                  if (passwordVerified) ...[
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Password verified successfully',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Security Notice
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'For security purposes, we require password verification before account deletion.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationStep({
    required String stepNumber,
    required String title,
    required bool isCompleted,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.successLight
                    : AppTheme.lightTheme.colorScheme.outline,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 16,
                      )
                    : Text(
                        stepNumber,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: isCompleted
                      ? AppTheme.successLight
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.only(left: 11.w),
          child: child,
        ),
      ],
    );
  }
}
