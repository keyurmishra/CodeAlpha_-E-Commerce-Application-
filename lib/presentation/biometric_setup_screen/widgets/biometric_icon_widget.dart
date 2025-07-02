import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricIconWidget extends StatefulWidget {
  final List<BiometricType> biometricTypes;
  final bool isAvailable;

  const BiometricIconWidget({
    super.key,
    required this.biometricTypes,
    required this.isAvailable,
  });

  @override
  State<BiometricIconWidget> createState() => _BiometricIconWidgetState();
}

class _BiometricIconWidgetState extends State<BiometricIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isAvailable) {
      _pulseController.repeat(reverse: true);
    }
  }

  String _getIconName() {
    if (widget.biometricTypes.contains(BiometricType.face)) {
      return 'face';
    } else if (widget.biometricTypes.contains(BiometricType.fingerprint)) {
      return 'fingerprint';
    } else if (widget.biometricTypes.contains(BiometricType.iris)) {
      return 'visibility';
    } else {
      return 'security';
    }
  }

  Color _getIconColor() {
    if (!widget.isAvailable) {
      return AppTheme.lightTheme.colorScheme.outline;
    }
    return AppTheme.lightTheme.colorScheme.primary;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isAvailable ? _pulseAnimation.value : 1.0,
          child: Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getIconColor().withValues(alpha: 0.1),
              border: Border.all(
                color: _getIconColor().withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getIconName(),
                color: _getIconColor(),
                size: 15.w,
              ),
            ),
          ),
        );
      },
    );
  }
}
