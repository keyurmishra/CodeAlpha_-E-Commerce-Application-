import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alternative_options_widget.dart';
import './widgets/confirmation_steps_widget.dart';
import './widgets/data_export_widget.dart';
import './widgets/deletion_warning_widget.dart';

class AccountDeletionScreen extends StatefulWidget {
  const AccountDeletionScreen({super.key});

  @override
  State<AccountDeletionScreen> createState() => _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends State<AccountDeletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _reasonController = TextEditingController();

  bool _acknowledgeDataLoss = false;
  bool _passwordVerified = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _selectedReason;
  final bool _showDataDetails = false;
  final bool _showAlternatives = false;

  final List<String> _deletionReasons = [
    'No longer need the account',
    'Privacy concerns',
    'Too many emails',
    'Found a better alternative',
    'Account security issues',
    'Other (please specify)'
  ];

  @override
  void dispose() {
    _passwordController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _verifyPassword() async {
    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter your password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Mock password verification - replace with actual Supabase auth
      await Future.delayed(const Duration(seconds: 2));

      // Mock credentials for demo
      if (_passwordController.text == 'user123' ||
          _passwordController.text == 'admin456') {
        setState(() {
          _passwordVerified = true;
          _isLoading = false;
        });
        _showSuccessSnackBar('Password verified successfully');
      } else {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Invalid password. Please try again.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Verification failed. Please try again.');
    }
  }

  Future<void> _downloadData() async {
    setState(() => _isLoading = true);

    try {
      // Mock data export process
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _isLoading = false);
      _showSuccessSnackBar(
          'Data export initiated. Check your email for download link.');
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to export data. Please try again.');
    }
  }

  Future<void> _deleteAccount() async {
    if (!_canDeleteAccount()) return;

    final confirmed = await _showFinalConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      // Mock account deletion process
      await Future.delayed(const Duration(seconds: 3));

      // Clear user session and navigate to registration
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/registration-screen',
          (route) => false,
        );
        _showSuccessSnackBar('Account deleted successfully');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to delete account. Please try again.');
    }
  }

  Future<bool> _showFinalConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Final Confirmation',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ],
            ),
            content: Text(
              'This action cannot be undone. Your account and all associated data will be permanently deleted.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onError,
                ),
                child: const Text('DELETE ACCOUNT'),
              ),
            ],
          ),
        ) ??
        false;
  }

  bool _canDeleteAccount() {
    return _acknowledgeDataLoss && _passwordVerified && !_isLoading;
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.successLight,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Delete Account'),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.error,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning Section
              DeletionWarningWidget(),

              SizedBox(height: 4.h),

              // Data Details Expandable Section
              Card(
                child: ExpansionTile(
                  leading: CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  title: Text(
                    'What data will be deleted?',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDataItem(
                              'Personal information and profile data'),
                          _buildDataItem('Order history and purchase records'),
                          _buildDataItem('Saved preferences and settings'),
                          _buildDataItem('Wishlist and saved items'),
                          _buildDataItem('Payment methods and addresses'),
                          SizedBox(height: 2.h),
                          Text(
                            'Note: Some data may be retained for legal compliance purposes for up to 7 years.',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Data Export Option
              DataExportWidget(
                onDownload: _downloadData,
                isLoading: _isLoading,
              ),

              SizedBox(height: 3.h),

              // Reason Selection
              Text(
                'Reason for deletion (optional)',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              DropdownButtonFormField<String>(
                value: _selectedReason,
                decoration: const InputDecoration(
                  hintText: 'Select a reason',
                ),
                items: _deletionReasons.map((reason) {
                  return DropdownMenuItem(
                    value: reason,
                    child: Text(reason),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedReason = value);
                },
              ),

              if (_selectedReason == 'Other (please specify)') ...[
                SizedBox(height: 2.h),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Please specify',
                    hintText: 'Tell us more about your reason',
                  ),
                  maxLines: 3,
                ),
              ],

              SizedBox(height: 4.h),

              // Alternative Options
              AlternativeOptionsWidget(
                onDeactivateAccount: () {
                  Navigator.of(context).pushNamed('/profile-management-screen');
                },
              ),

              SizedBox(height: 4.h),

              // Confirmation Steps
              ConfirmationStepsWidget(
                acknowledgeDataLoss: _acknowledgeDataLoss,
                passwordController: _passwordController,
                passwordVerified: _passwordVerified,
                isPasswordVisible: _isPasswordVisible,
                isLoading: _isLoading,
                onAcknowledgeChanged: (value) {
                  setState(() => _acknowledgeDataLoss = value ?? false);
                },
                onPasswordVisibilityToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
                onVerifyPassword: _verifyPassword,
              ),

              SizedBox(height: 4.h),

              // Delete Account Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _canDeleteAccount() ? _deleteAccount : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onError,
                    disabledBackgroundColor:
                        AppTheme.lightTheme.colorScheme.outline,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onError,
                            ),
                          ),
                        )
                      : Text(
                          'DELETE ACCOUNT',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onError,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'circle',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 8,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
