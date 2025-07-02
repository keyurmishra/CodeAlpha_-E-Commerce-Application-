import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BenefitsCardWidget extends StatelessWidget {
  const BenefitsCardWidget({super.key});

  final List<Map<String, dynamic>> benefits = const [
    {
      "icon": "flash_on",
      "title": "Faster Login",
      "description":
          "Access your account in seconds with just a touch or glance"
    },
    {
      "icon": "security",
      "title": "Enhanced Security",
      "description":
          "Your unique biometric data provides stronger protection than passwords"
    },
    {
      "icon": "smartphone",
      "title": "Convenient Access",
      "description":
          "No need to remember or type passwords on your mobile device"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: benefits
          .map((benefit) => _buildBenefitItem(
                benefit["icon"] as String,
                benefit["title"] as String,
                benefit["description"] as String,
              ))
          .toList(),
    );
  }

  Widget _buildBenefitItem(String iconName, String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
