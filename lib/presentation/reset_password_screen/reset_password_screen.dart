import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/password_requirements_widget.dart';
import './widgets/password_strength_indicator_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isTokenValid = true;

  // Password strength tracking
  double _passwordStrength = 0.0;
  List<String> _unmetRequirements = [
    'At least 8 characters',
    'One uppercase letter',
    'One lowercase letter',
    'One number',
    'One special character'
  ];

  @override
  void initState() {
    super.initState();
    _validateResetToken();
    _newPasswordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateResetToken() {
    // Mock token validation - in real app, validate with Supabase
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Simulate token validation
        final isValid =
            DateTime.now().millisecondsSinceEpoch % 10 != 0; // 90% success rate
        if (!isValid) {
          setState(() {
            _isTokenValid = false;
          });
          _showErrorAndRedirect('Reset token has expired or is invalid');
        }
      }
    });
  }

  void _onPasswordChanged() {
    final password = _newPasswordController.text;
    final strength = _calculatePasswordStrength(password);
    final requirements = _getUnmetRequirements(password);

    setState(() {
      _passwordStrength = strength;
      _unmetRequirements = requirements;
    });
  }

  void _onConfirmPasswordChanged() {
    // Clear confirm password if it doesn't match to prevent confusion
    if (_confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text != _newPasswordController.text) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted &&
            _confirmPasswordController.text != _newPasswordController.text) {
          _confirmPasswordController.clear();
        }
      });
    }
  }

  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$&*~]'))) score++;

    return score / 5.0;
  }

  List<String> _getUnmetRequirements(String password) {
    List<String> unmet = [];

    if (password.length < 8) unmet.add('At least 8 characters');
    if (!password.contains(RegExp(r'[A-Z]'))) unmet.add('One uppercase letter');
    if (!password.contains(RegExp(r'[a-z]'))) unmet.add('One lowercase letter');
    if (!password.contains(RegExp(r'[0-9]'))) unmet.add('One number');
    if (!password.contains(RegExp(r'[!@#\$&*~]'))) {
      unmet.add('One special character');
    }

    return unmet;
  }

  bool _isPasswordStrong() {
    return _passwordStrength >= 0.8 && _unmetRequirements.isEmpty;
  }

  bool _doPasswordsMatch() {
    return _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text;
  }

  bool _canUpdatePassword() {
    return _isPasswordStrong() && _doPasswordsMatch() && !_isLoading;
  }

  void _showErrorAndRedirect(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/forgot-password-screen');
      }
    });
  }

  Future<void> _updatePassword() async {
    if (!_canUpdatePassword()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Mock Supabase API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate API response
      final success =
          DateTime.now().millisecondsSinceEpoch % 10 != 0; // 90% success rate

      if (success) {
        _showSuccessAndNavigate();
      } else {
        throw Exception('Failed to update password');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update password. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Password updated successfully!'),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isTokenValid) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'error_outline',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 15.w,
                ),
                SizedBox(height: 3.h),
                Text(
                  'Invalid Reset Link',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  'This reset link has expired or is invalid. Please request a new password reset.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async => false, // Disable back button for security
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),

                  // Lock icon
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'lock_reset',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 10.w,
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Title
                  Text(
                    'Reset Your Password',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 2.h),

                  // Instructions
                  Text(
                    'Create a strong new password for your account. Make sure it meets all the requirements below.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 6.h),

                  // New Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Password',
                        style: AppTheme.lightTheme.textTheme.labelLarge,
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_isNewPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter your new password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: _isNewPasswordVisible
                                  ? 'visibility_off'
                                  : 'visibility',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 5.w,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (!_isPasswordStrong()) {
                            return 'Password does not meet requirements';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Password Strength Indicator
                  if (_newPasswordController.text.isNotEmpty)
                    PasswordStrengthIndicatorWidget(
                      strength: _passwordStrength,
                    ),

                  SizedBox(height: 3.h),

                  // Password Requirements
                  PasswordRequirementsWidget(
                    unmetRequirements: _unmetRequirements,
                  ),

                  SizedBox(height: 4.h),

                  // Confirm Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: AppTheme.lightTheme.textTheme.labelLarge,
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirm your new password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: _isConfirmPasswordVisible
                                  ? 'visibility_off'
                                  : 'visibility',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 5.w,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Update Password Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _canUpdatePassword() ? _updatePassword : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canUpdatePassword()
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              'Update Password',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Back to Login Link
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login-screen');
                    },
                    child: Text(
                      'Back to Login',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
