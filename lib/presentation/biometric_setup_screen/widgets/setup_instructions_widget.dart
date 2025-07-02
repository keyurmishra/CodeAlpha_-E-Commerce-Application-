import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SetupInstructionsWidget extends StatelessWidget {
  final String biometricType;

  const SetupInstructionsWidget({
    super.key,
    required this.biometricType,
  });

  List<Map<String, String>> get _getInstructions {
    if (biometricType.toLowerCase().contains('face')) {
      return [
        {
          "step": "1",
          "instruction": "Position your face within the camera frame"
        },
        {
          "step": "2",
          "instruction": "Look directly at your device's front camera"
        },
        {
          "step": "3",
          "instruction": "Follow the on-screen prompts to complete setup"
        }
      ];
    } else if (biometricType.toLowerCase().contains('fingerprint')) {
      return [
        {
          "step": "1",
          "instruction": "Place your finger on the fingerprint sensor"
        },
        {
          "step": "2",
          "instruction": "Lift and place your finger multiple times"
        },
        {
          "step": "3",
          "instruction": "Adjust finger position for complete coverage"
        }
      ];
    } else {
      return [
        {
          "step": "1",
          "instruction": "Follow your device's authentication prompts"
        },
        {
          "step": "2",
          "instruction": "Complete the biometric verification process"
        },
        {"step": "3", "instruction": "Confirm the setup when prompted"}
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Setup Instructions',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ..._getInstructions
              .map((instruction) => _buildInstructionStep(
                    instruction["step"]!,
                    instruction["instruction"]!,
                  ))
              ,
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String step, String instruction) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              instruction,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
