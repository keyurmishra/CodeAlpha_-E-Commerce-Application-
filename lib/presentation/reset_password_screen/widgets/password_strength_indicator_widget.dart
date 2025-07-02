import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PasswordStrengthIndicatorWidget extends StatelessWidget {
  final double strength;

  const PasswordStrengthIndicatorWidget({
    super.key,
    required this.strength,
  });

  Color _getStrengthColor() {
    if (strength < 0.3) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (strength < 0.7) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.successLight;
    }
  }

  String _getStrengthText() {
    if (strength < 0.3) {
      return 'Weak';
    } else if (strength < 0.7) {
      return 'Medium';
    } else {
      return 'Strong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength',
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
            Text(
              _getStrengthText(),
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: _getStrengthColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          height: 1.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(0.5.h),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: strength,
            child: Container(
              decoration: BoxDecoration(
                color: _getStrengthColor(),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
