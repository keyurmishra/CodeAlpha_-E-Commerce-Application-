import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginActivitySectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const LoginActivitySectionWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    // Mock login activity data
    final List<Map<String, dynamic>> loginActivity = [
      {
        "device": "iPhone 14 Pro",
        "location": "New York, NY",
        "timestamp": "2024-01-15 10:30 AM",
        "ipAddress": "192.168.1.100",
        "isCurrent": true,
      },
      {
        "device": "MacBook Pro",
        "location": "New York, NY",
        "timestamp": "2024-01-14 08:45 PM",
        "ipAddress": "192.168.1.101",
        "isCurrent": false,
      },
      {
        "device": "iPad Air",
        "location": "Brooklyn, NY",
        "timestamp": "2024-01-13 02:15 PM",
        "ipAddress": "10.0.0.50",
        "isCurrent": false,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Login Activity',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    _showAllActivityDialog(context, loginActivity);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View All',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Recent login activities (show only first 2)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: loginActivity.length > 2 ? 2 : loginActivity.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
              height: 1,
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final activity = loginActivity[index];
              return _buildActivityItem(activity);
            },
          ),

          if (loginActivity.length > 2)
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    _showAllActivityDialog(context, loginActivity);
                  },
                  child: Text(
                    'View ${loginActivity.length - 2} more sessions',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: (activity["isCurrent"] as bool)
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: _getDeviceIcon(activity["device"] as String),
            color: (activity["isCurrent"] as bool)
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              activity["device"] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (activity["isCurrent"] as bool)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Current',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 12,
              ),
              SizedBox(width: 1.w),
              Text(
                activity["location"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 12,
              ),
              SizedBox(width: 1.w),
              Text(
                activity["timestamp"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: !(activity["isCurrent"] as bool)
          ? IconButton(
              onPressed: () {
                _showTerminateSessionDialog(activity);
              },
              icon: CustomIconWidget(
                iconName: 'logout',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 18,
              ),
              tooltip: 'Terminate session',
            )
          : null,
    );
  }

  String _getDeviceIcon(String device) {
    if (device.toLowerCase().contains('iphone') ||
        device.toLowerCase().contains('android')) {
      return 'phone_android';
    } else if (device.toLowerCase().contains('ipad') ||
        device.toLowerCase().contains('tablet')) {
      return 'tablet';
    } else if (device.toLowerCase().contains('mac') ||
        device.toLowerCase().contains('windows')) {
      return 'laptop';
    }
    return 'devices';
  }

  void _showAllActivityDialog(
      BuildContext context, List<Map<String, dynamic>> activities) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'All Login Activity',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: activities.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(activity);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTerminateSessionDialog(Map<String, dynamic> activity) {
    // This would show a confirmation dialog for terminating a session
    // Implementation would depend on the specific requirements
  }
}
