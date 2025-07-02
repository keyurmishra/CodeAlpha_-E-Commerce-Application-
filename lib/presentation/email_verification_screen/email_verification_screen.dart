import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import './widgets/verification_actions_widget.dart';
import './widgets/verification_footer_widget.dart';
import './widgets/verification_header_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with WidgetsBindingObserver {
  bool _isResendLoading = false;
  int _resendCountdown = 0;
  String _userEmail = '';
  DateTime? _lastResendTime;

  // Mock user data
  final Map<String, dynamic> _mockUserData = {
    "email": "john.doe@example.com",
    "firstName": "John",
    "isVerified": false,
    "registrationTime": DateTime.now().subtract(const Duration(minutes: 5)),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVerificationStatus();
    }
  }

  Future<void> _initializeScreen() async {
    await _loadUserData();
    await _loadResendTimer();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email =
          prefs.getString('user_email') ?? _mockUserData['email'] as String;
      setState(() {
        _userEmail = email;
      });
    } catch (e) {
      setState(() {
        _userEmail = _mockUserData['email'] as String;
      });
    }
  }

  Future<void> _loadResendTimer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastResendTimestamp = prefs.getInt('last_resend_timestamp');

      if (lastResendTimestamp != null) {
        final lastResend =
            DateTime.fromMillisecondsSinceEpoch(lastResendTimestamp);
        final timeDifference = DateTime.now().difference(lastResend).inSeconds;

        if (timeDifference < 60) {
          setState(() {
            _resendCountdown = 60 - timeDifference;
            _lastResendTime = lastResend;
          });
          _startCountdownTimer();
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _startCountdownTimer() {
    if (_resendCountdown > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _resendCountdown > 0) {
          setState(() {
            _resendCountdown--;
          });
          _startCountdownTimer();
        }
      });
    }
  }

  Future<void> _checkVerificationStatus() async {
    try {
      // Mock verification check
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate random verification success (10% chance)
      final isVerified = DateTime.now().millisecond % 10 == 0;

      if (isVerified) {
        _showVerificationSuccess();
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _showVerificationSuccess() {
    Fluttertoast.showToast(
      msg: "Email verified successfully! Redirecting to login...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: AppTheme.lightTheme.colorScheme.onPrimary,
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendCountdown > 0 || _isResendLoading) return;

    setState(() {
      _isResendLoading = true;
    });

    try {
      // Mock API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Save resend timestamp
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      await prefs.setInt('last_resend_timestamp', now.millisecondsSinceEpoch);

      setState(() {
        _resendCountdown = 60;
        _lastResendTime = now;
        _isResendLoading = false;
      });

      _startCountdownTimer();

      Fluttertoast.showToast(
        msg: "Verification email sent successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      );
    } catch (e) {
      setState(() {
        _isResendLoading = false;
      });

      Fluttertoast.showToast(
        msg: "Failed to send email. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    }
  }

  Future<void> _openEmailApp() async {
    try {
      // Try to open default email app
      const emailUrl = 'mailto:';
      if (await canLaunchUrl(Uri.parse(emailUrl))) {
        await launchUrl(Uri.parse(emailUrl));
      } else {
        // Fallback for devices without email app
        Fluttertoast.showToast(
          msg: "No email app found. Please check your email manually.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Unable to open email app",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _changeEmail() {
    Navigator.pop(context);
  }

  void _skipVerification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Skip Verification?',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'You can continue with limited features. Some functionality will be restricted until you verify your email.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, '/profile-management-screen');
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _backToLogin() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: VerificationHeaderWidget(
                    userEmail: _userEmail,
                  ),
                ),
                SizedBox(height: 4.h),
                Expanded(
                  flex: 2,
                  child: VerificationActionsWidget(
                    isResendLoading: _isResendLoading,
                    resendCountdown: _resendCountdown,
                    onOpenEmailApp: _openEmailApp,
                    onResendEmail: _resendVerificationEmail,
                    onChangeEmail: _changeEmail,
                  ),
                ),
                SizedBox(height: 3.h),
                Expanded(
                  flex: 1,
                  child: VerificationFooterWidget(
                    onSkipVerification: _skipVerification,
                    onBackToLogin: _backToLogin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
