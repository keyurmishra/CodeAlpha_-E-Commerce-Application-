import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_security_section_widget.dart';
import './widgets/login_activity_section_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/privacy_section_widget.dart';
import './widgets/profile_avatar_widget.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Controllers for form fields
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // State variables
  bool _hasChanges = false;
  bool _isLoading = false;
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;
  String _profileImageUrl = '';

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": "user_123",
    "displayName": "John Doe",
    "email": "john.doe@example.com",
    "phone": "+1 (555) 123-4567",
    "profileImage":
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
    "joinDate": "2023-01-15",
    "lastLogin": "2024-01-15 10:30 AM",
    "emailVerified": true,
    "phoneVerified": false,
  };

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    _displayNameController.text = _userData["displayName"] as String;
    _emailController.text = _userData["email"] as String;
    _phoneController.text = _userData["phone"] as String;
    _profileImageUrl = _userData["profileImage"] as String;

    // Add listeners to detect changes
    _displayNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges =
        _displayNameController.text != _userData["displayName"] ||
            _emailController.text != _userData["email"] ||
            _phoneController.text != _userData["phone"];

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  void _onProfileImageChanged(String newImageUrl) {
    setState(() {
      _profileImageUrl = newImageUrl;
      _hasChanges = true;
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Update user data
    _userData["displayName"] = _displayNameController.text;
    _userData["email"] = _emailController.text;
    _userData["phone"] = _phoneController.text;
    _userData["profileImage"] = _profileImageUrl;

    setState(() {
      _isLoading = false;
      _hasChanges = false;
    });

    Fluttertoast.showToast(
      msg: "Profile updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile Management',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveChanges,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Avatar Section
              ProfileAvatarWidget(
                imageUrl: _profileImageUrl,
                displayName: _displayNameController.text,
                onImageChanged: _onProfileImageChanged,
              ),

              SizedBox(height: 3.h),

              // Personal Information Section
              PersonalInfoSectionWidget(
                displayNameController: _displayNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                userData: _userData,
              ),

              SizedBox(height: 3.h),

              // Account Security Section
              AccountSecuritySectionWidget(
                twoFactorEnabled: _twoFactorEnabled,
                biometricEnabled: _biometricEnabled,
                onTwoFactorChanged: (value) {
                  setState(() {
                    _twoFactorEnabled = value;
                    _hasChanges = true;
                  });
                },
                onBiometricChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                    _hasChanges = true;
                  });
                },
                onPasswordChangePressed: () =>
                    _navigateToScreen('/reset-password-screen'),
                onBiometricSetupPressed: () =>
                    _navigateToScreen('/biometric-setup-screen'),
              ),

              SizedBox(height: 3.h),

              // Login Activity Section
              LoginActivitySectionWidget(
                userData: _userData,
              ),

              SizedBox(height: 3.h),

              // Privacy Section
              PrivacySectionWidget(
                onAccountDeletionPressed: () =>
                    _navigateToScreen('/account-deletion-screen'),
              ),

              SizedBox(height: 10.h), // Extra space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: _hasChanges
          ? Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Saving Changes...',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Save Changes',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
