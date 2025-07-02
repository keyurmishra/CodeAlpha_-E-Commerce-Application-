import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/benefits_card_widget.dart';
import './widgets/biometric_icon_widget.dart';
import './widgets/setup_instructions_widget.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen>
    with TickerProviderStateMixin {
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  bool _isBiometricEnrolled = false;
  List<BiometricType> _availableBiometrics = [];
  String _biometricTypeText = 'Biometric';
  String _deviceInstructions = '';

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool isAvailable = await _localAuth.isDeviceSupported();
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();

      setState(() {
        _isBiometricAvailable = isAvailable && canCheckBiometrics;
        _availableBiometrics = availableBiometrics;
        _isBiometricEnrolled = availableBiometrics.isNotEmpty;
        _updateBiometricTypeText();
        _updateDeviceInstructions();
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
        _isBiometricEnrolled = false;
      });
    }
  }

  void _updateBiometricTypeText() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      _biometricTypeText = 'Face Recognition';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      _biometricTypeText = 'Fingerprint';
    } else if (_availableBiometrics.contains(BiometricType.iris)) {
      _biometricTypeText = 'Iris Recognition';
    } else {
      _biometricTypeText = 'Biometric Authentication';
    }
  }

  void _updateDeviceInstructions() {
    if (!_isBiometricAvailable) {
      _deviceInstructions =
          'Biometric authentication is not available on this device.';
    } else if (!_isBiometricEnrolled) {
      if (_availableBiometrics.isEmpty) {
        _deviceInstructions =
            'No biometric authentication methods are enrolled. Please set up fingerprint or face recognition in your device settings.';
      }
    } else {
      _deviceInstructions =
          'Your device supports $_biometricTypeText. Enable it for faster and more secure login.';
    }
  }

  Future<void> _enableBiometricLogin() async {
    if (!_isBiometricAvailable) {
      _showErrorMessage(
          'Biometric authentication is not available on this device.');
      return;
    }

    if (!_isBiometricEnrolled) {
      _showEnrollmentDialog();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason:
            'Please authenticate to enable biometric login for EcomAuth',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        await _saveBiometricPreference(true);
        _showSuccessDialog();
      } else {
        _showErrorMessage('Authentication failed. Please try again.');
      }
    } on PlatformException catch (e) {
      String errorMessage = 'Authentication error occurred.';

      switch (e.code) {
        case 'NotAvailable':
          errorMessage = 'Biometric authentication is not available.';
          break;
        case 'NotEnrolled':
          errorMessage = 'No biometric authentication methods are enrolled.';
          break;
        case 'LockedOut':
          errorMessage =
              'Biometric authentication is temporarily locked. Please try again later.';
          break;
        case 'PermanentlyLockedOut':
          errorMessage =
              'Biometric authentication is permanently locked. Please use device passcode.';
          break;
        default:
          errorMessage = e.message ?? 'Authentication failed.';
      }

      _showErrorMessage(errorMessage);
    } catch (e) {
      _showErrorMessage('An unexpected error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveBiometricPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', enabled);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 10.w,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Biometric Login Enabled!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'You can now use $_biometricTypeText to quickly and securely access your account.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEnrollmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Setup Required',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'To enable biometric login, you need to set up $_biometricTypeText in your device settings first.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openDeviceSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _openDeviceSettings() {
    // This would typically open device settings
    // For demo purposes, we'll show a toast
    Fluttertoast.showToast(
      msg: 'Please set up biometric authentication in your device settings',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: AppTheme.lightTheme.colorScheme.onError,
    );
  }

  void _skipSetup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Skip Biometric Setup?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You can always enable biometric login later from your profile settings.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Skip'),
            ),
          ],
        );
      },
    );
  }

  void _showLearnMore() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Biometric Security',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildLearnMoreSection(
                      'How It Works',
                      'Biometric authentication uses your unique physical characteristics like fingerprints or facial features to verify your identity. This data is stored securely on your device and never shared with our servers.',
                    ),
                    _buildLearnMoreSection(
                      'Security',
                      'Your biometric data is encrypted and stored in your device\'s secure enclave or trusted execution environment. We cannot access this information, ensuring your privacy and security.',
                    ),
                    _buildLearnMoreSection(
                      'Privacy',
                      'EcomAuth does not collect, store, or transmit your biometric data. All authentication happens locally on your device using your operating system\'s built-in security features.',
                    ),
                    _buildLearnMoreSection(
                      'Fallback Options',
                      'If biometric authentication fails or is unavailable, you can always use your email and password to access your account. Your account security is never compromised.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnMoreSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Biometric Setup',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _showLearnMore,
            child: Text(
              'Learn More',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                children: [
                  SizedBox(height: 4.h),

                  // Biometric Icon
                  BiometricIconWidget(
                    biometricTypes: _availableBiometrics,
                    isAvailable: _isBiometricAvailable,
                  ),

                  SizedBox(height: 4.h),

                  // Title and Description
                  Text(
                    'Enable $_biometricTypeText',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    _deviceInstructions,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h),

                  // Benefits Cards
                  BenefitsCardWidget(),

                  SizedBox(height: 4.h),

                  // Setup Instructions
                  if (_isBiometricAvailable && _isBiometricEnrolled)
                    SetupInstructionsWidget(biometricType: _biometricTypeText),

                  SizedBox(height: 6.h),

                  // Action Buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _enableBiometricLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isBiometricAvailable && _isBiometricEnrolled
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline,
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
                                  _isBiometricAvailable && _isBiometricEnrolled
                                      ? 'Enable $_biometricTypeText'
                                      : 'Setup Not Available',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: _isBiometricAvailable &&
                                            _isBiometricEnrolled
                                        ? AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: OutlinedButton(
                          onPressed: _skipSetup,
                          child: Text(
                            'Skip for Now',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
